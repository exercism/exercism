require 'delegate'

module ExercismLegacy
  class Alert < SimpleDelegator
    def id
      "alert-#{__getobj__.id}"
    end

    def hibernation?
      regarding == 'hibernating'
    end

    def regarding
      case text
      when /hibernation/i
        'hibernating'
      when /invitation/i
        'invitation'
      else
        'info'
      end
    end

    def count
      0
    end

    def link
      url
    end

    def recipient
      user.username
    end

    def note
      s = text
      if url
        s += " <a href='#{url}'>#{link_text || url}</a>"
      end
      s
    end

    def slug
    end

    def language
    end

    def username
    end

    def team_name
    end
  end
end
