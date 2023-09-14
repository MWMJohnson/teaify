require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }

    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:frequency) }
    
    
    it { should validate_presence_of(:tea_units) }
    it { should validate_numericality_of(:tea_units) }

    it { should validate_presence_of(:tea_unit_size) }
    it { should validate_numericality_of(:tea_unit_size) }
  end

  describe 'relationships' do
    it { should belong_to(:tea).optional }
    it { should belong_to(:customer).optional }
  end
end
