module Cudan
    class XpathCudan < BaseCudan
        require 'nokogiri'
        def do_query query
            @doc = Nokogiri::HTML(@response)
            @result = @doc.search(query)
            @result = @result[0]
            if @result.is_a? Nokogiri::XML::Text
                return @result.content
            elsif @result
                @result.inner_html
            else
                ''
            end
        end
        def do_expect expect
            p @query_result
            @query_result.include? expect
        end
    end
end
