module RubyImageServer
  module Publishers
    class MissingImage
      include Lapine::Publisher

      exchange 'images.missing'

      def initialize(namespace: nil, image_hash: nil)
        @namespace = namespace
        @image_hash = image_hash
      end

      def to_hash
        {
          namespace: @namespace,
          image_hash: @image_hash
        }
      end
    end
  end
end
