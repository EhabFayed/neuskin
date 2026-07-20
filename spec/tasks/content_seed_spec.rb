require "rails_helper"
require "rake"

RSpec.describe "content:seed", type: :task do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?("content:seed")
  end

  before { Rake::Task["content:seed"].reenable }

  it "creates the home hero section idempotently" do
    expect { Rake::Task["content:seed"].invoke }.to change { Section.count }.by_at_least(1)

    hero = Section.for("home", "home_hero")
    expect(hero).to be_persisted

    I18n.with_locale(:en) do
      expect(hero.text("headline_1")).to be_present
      expect(hero.text("headline_1")).to eq("Medical Precision.")
    end

    Rake::Task["content:seed"].reenable
    expect { Rake::Task["content:seed"].invoke }.not_to change { Section.count }
  end
end
