module Cudan
    class RegexpCudan < BaseCudan
        def do_query query
            regexp = Regexp::new(query)
            @matched = regexp.match(@response)
            if @matched
                @matched[0]
            else
                ''
            end
        end
        def do_expect expect
            nexpect = expect.gsub(/\\\d/){|m|
                @matched[m.to_i].to_s
            }
            @query_result.include? nexpect
        end
    end
end
