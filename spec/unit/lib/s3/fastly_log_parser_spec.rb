require 'ruby_image_server/s3/fastly_log_parser'

RSpec.describe RubyImageServer::S3::FastlyLogParser do
  subject { described_class.new(log) }

  context 'the log contains valid image hashes' do
    let(:log) { fastly_404_log }

    it 'returns all valid image hash maps' do
      expect(subject.image_hashes).to eq([
            { namespace: 'p', image_hash: '9783680f4401cafccc7f527118ed8a85' },
            { namespace: 'p', image_hash: '829b0b7868e8c3d7d693e6a1f6a44726' },
            { namespace: 'p', id: '11196146' }
          ])
    end
  end

  context 'the log does not contain image hashes' do
    let(:log) { StringIO.new("\n\n\n") }

    it 'returns an empty array' do
      expect(subject.image_hashes).to eq([])
    end
  end
end
