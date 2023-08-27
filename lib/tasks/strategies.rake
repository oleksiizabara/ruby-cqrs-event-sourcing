namespace :strategies do
  desc 'Create strategies'
  task create: :environment do
    recorder = Snapshots::Recorders::Strategy.new('strategies')

    [
      { name: 'Aggressive', description: 'Increases the offense and decreases the defense of your team, giving them a boost in confidence and energy to win.', defense_delta: -10, offense_delta: 10 },
      { name: 'Balanced', defense_delta: 0, offense_delta: 0, description: 'Balances the offense and defense of your team, making them more well-rounded and effective.' },
      { name: 'Defensive', defense_delta: 10, offense_delta: -10, description: 'Increases the defense and decreases the offense of your team, making them more resilient and harder to defeat.' }
    ].each do |strategy|
      Strategy.transaction do
        new_strategy = Strategy.create!(strategy)

        recorder.save(Snapshots::Entries::Strategy.new(id: new_strategy.id,
                                                       name: new_strategy.name,
                                                       description: new_strategy.description,
                                                       stats_delta: {
                                                         offense: new_strategy.offense_delta,
                                                         defense: new_strategy.defense_delta
                                                       }))
      end
    end
  end
end
