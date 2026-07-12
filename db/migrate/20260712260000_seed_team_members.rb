# Data migration: seed the four launch team members on existing databases
# (deploys run pending migrations, not db:seed; fresh DBs get them from
# db/seeds.rb), then retire the old fixed-key the_team/team_members section —
# the page reads TeamMember records now.
class SeedTeamMembers < ActiveRecord::Migration[8.0]
  def up
    seed_file = Rails.root.join("db/seeds/team_members.rb")
    load seed_file if File.exist?(seed_file)
    say "Team members in DB: #{TeamMember.count}"

    Section.find_by(page: "the_team", kind: "team_members")&.destroy
  end

  def down
    # Data, not schema — nothing to reverse.
  end
end
