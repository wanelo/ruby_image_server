require 'ruby_image_server/s3/missing_image_finder'

RSpec.describe RubyImageServer::S3::MissingImageFinder do
  let(:hashies) do
    [
      {
        namespace: 'p1',
        image_hash: 'poo'
      },
      {
        namespace: 'p2',
        id: 123
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
        s3.stub_responses(:list_objects, contents: [{key: 'key1'}, {key: 'key2'}])
        s3.stub_responses(:get_object, body: StringIO.new('string from log'))

        allow(RubyImageServer::S3::FastlyLogParser).to receive(:new) { double(image_hashes: hashies) }
      end

      it 'returns an array of hashes' do
        expect(subject.image_data).to be_a_kind_of(Array)
      end

      it 'matches items with image hash' do
        datum = subject.image_data[0]
        expect(datum[:namespace]).to eq('p1')
        expect(datum[:image_hash]).to eq('poo')
        expect(datum[:id]).to eq(nil)
      end

      it 'matches item with id' do
        datum = subject.image_data[1]
        expect(datum[:namespace]).to eq('p2')
        expect(datum[:image_hash]).to eq(nil)
        expect(datum[:id]).to eq(123)
      end
    end
  end
end
