require_relative '../test_helper'
require_relative '../../lib/exercism/progress_bar'

class ProgressBarTest < Minitest::Test
  def test_install
    %w(install-cli submit-code have-a-conversation pay-it-forward).each {|step|
      refute ProgressBar.fill?(step, 'install-cli')
    }
  end

  def test_submit
    assert ProgressBar.fill?('install-cli', 'submit-code')

    %w(submit-code have-a-conversation pay-it-forward).each {|step|
      refute ProgressBar.fill?(step, 'submit-code')
    }
  end

  def test_converse
    %w(install-cli submit-code).each {|step|
      assert ProgressBar.fill?(step, 'have-a-conversation')
    }
    %w(have-a-conversation pay-it-forward).each {|step|
      refute ProgressBar.fill?(step, 'have-a-conversation')
    }
  end

  def test_nitpick
    %w(install-cli submit-code have-a-conversation).each {|step|
      assert ProgressBar.fill?(step, 'pay-it-forward')
    }
    %w(pay-it-forward).each {|step|
      refute ProgressBar.fill?(step, 'pay-it-forward')
    }
  end

  def test_explore
    %w(install-cli submit-code have-a-conversation pay-it-forward).each {|step|
      assert ProgressBar.fill?(step, 'explore')
    }
  end
end
