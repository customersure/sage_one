require 'spec_helper'

describe SageOne::VERSION do
  it 'sets the VERSION constant' do
    SageOne::VERSION.should_not be_nil
  end
end