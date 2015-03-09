require 'ruby_image_server/s3/missing_image_finder'

RSpec.describe RubyImageServer::S3::MissingImageFinder do
  let(:hashies) do
    [
      {
        namespace: 'p',
        image_hash: 'poo'
      },
      {
        namespace: 'p',
        image_hash: 'poo'
      }
    ]
  end

  let(:s3) { Aws::S3::Client.new(stub_responses: true, region: 'someregion') }

  subject { described_class.new(s3: s3, bucket: 'test', base_path: '/') }

  describe '#image_data' do
    context 'when there are no hashes in S3' do
      it 'returns an empty array' do
        expect(subject.image_data).to eq([])
      end
    end

    context 'when there is data in S3' do
      before do
        s3.stub_responses(:list_objects, contents: [ { key: 'key1' }, { key: 'key2' } ])
        s3.stub_responses(:get_object, body: StringIO.new('string from log'))

        allow(RubyImageServer::S3::FastlyLogParser).to receive(:new) { double(image_hashes: hashies) }
      end

      it 'returns an array of image data hashes' do
        expect(subject.image_data).to be_a_kind_of(Array)
        subject.image_data.each do |datum|
          expect(datum[:namespace]).to eq('p')
          expect(datum[:image_hash]).to eq('poo')
        end
      end
    end
  end
end
