module Odnoklassniki
  module Utils

    class << self

      def _symbolize_keys(hash)
        symbolized = {}
        hash.each do |k, v|
          v = _symbolize_keys(v) if v.is_a?(Hash)
          symbolized[k.to_sym] = v
        end
        symbolized
      end

    end

  end
end
