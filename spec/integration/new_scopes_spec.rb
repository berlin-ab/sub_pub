require 'spec_helper'

describe "new scopes" do
  with_model :FakeActiveRecordUser do
    table do |t|
      t.string :title
    end

    model do
      has_many :fake_active_record_results
      has_many :approved_fake_active_record_results, -> {
        approved
      }, class_name: 'FakeActiveRecordResult'
    end
  end

  with_model :FakeActiveRecordResult do
    table do |t|
      t.string :title
      t.integer :fake_active_record_user_id
      t.boolean :approved
    end

    model do
      def self.approved
        where(approved: true)
      end
    end
  end

  describe "testing" do
    it "should work" do
      foo = FakeActiveRecordUser.create(title: 'foo')
      bar = FakeActiveRecordResult.create!(title: 'bar', approved: true, fake_active_record_user_id: foo.id)
      baz = FakeActiveRecordResult.create!(title: 'baz', approved: false, fake_active_record_user_id: foo.id)

      foo.approved_fake_active_record_results.should == [bar]
    end
  end
end
