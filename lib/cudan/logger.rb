class Cudan::Logger
    @@level = 7
    def self::setlevel level
        @@level = level
    end
    def self::log(message, level=7)
        if level <= @@level
            puts message
        end
    end
end
