module RubyImageServer
  module Publishers
    class MissingImage
      include Lapine::Publisher

      def initialize(namespace: nil, image_hash: nil, id: nil)
        @namespace = namespace
        @image_hash = image_hash
        @id = id
      end

      def to_hash
        {
          namespace: @namespace,
          image_hash: @image_hash,
          id: @id,
        }
      end
    end
  end
end
