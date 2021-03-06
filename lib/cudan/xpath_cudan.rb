module Cudan
    class XpathCudan < BaseCudan
        require 'nokogiri'
        def do_query query
            @doc = Nokogiri::HTML(@response)
            @result = @doc.search(query)
            @result = @result[0]
            if @result.is_a? Nokogiri::XML::Text
                return @result.content.to_s
            elsif @result
                return @result.inner_html.to_s
            else
                return ''
            end
        end
        def do_expect expect
            @query_result.include? expect
        end
    end
end
