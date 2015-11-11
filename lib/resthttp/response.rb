module Resthttp

  # This class represents all responses from server
  class Response < Hash
    attr_reader :raw_response,:body

    def initialize(response)
      @raw_response = response
      @error = {}
      @body = JSON.parse(@raw_response.body) rescue {}
      if @body.empty?
        @error["message"] =  @raw_response.body rescue @raw_response
      else
        @body.each do |k,v|
          self[k] = v
        end
      end
    end

    def is_ok?
      @raw_response.code == "200"
    end
    alias :success? :is_ok?

    def status_code
      @raw_response.code
    end

    def errors
      self["error"] || @error["message"]
    end

    protected

    def method_missing(name, *args, &block)
      if self.include?(name.to_s)
        self[name.to_s]
      else
        super(name, *args, &block)
      end
    end

  end
end

