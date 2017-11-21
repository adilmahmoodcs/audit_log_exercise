class Patient < ActiveRecord::Base
    include TrackActivityLog
end
