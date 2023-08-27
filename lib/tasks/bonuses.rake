
namespace :bonuses do
  desc "Create bonuses"
  task create: :environment do
    recorder = Snapshots::Recorders::Bonus.new("bonuses")

    [
      { name: 'Lucky Charm', description: 'Increases the morale and offence of your team, giving them a boost in confidence and energy to win.', affect_home_team: true, duration: 30, defense_delta: 0, offense_delta: 10, speed_delta: 0, stamina_delta: 0, health_delta: 0, morale_delta: 10 },
      { name: 'Iron Shield', description: 'Increases the defence and health of your team, making them more resilient and harder to defeat.', affect_home_team: true, duration: 30, defense_delta: 10, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: 10, morale_delta: 0 },
      { name: 'Power Surge', description: 'Increases the offence and health of your team, giving them a burst of power and energy to dominate the game.', affect_home_team: true, duration: 30, defense_delta: 0, offense_delta: 10, speed_delta: 0, stamina_delta: 0, health_delta: 10, morale_delta: 0 },
      { name: 'Healing Touch', description: 'Increases the health of your team, helping them recover from injuries and stay in the game longer.', affect_home_team: true, duration: 30, defense_delta: 0, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: 10, morale_delta: 0 },
      { name: 'Spirit Boost', description: 'Increases the morale and defence of your team, giving them a mental and physical edge over their opponents.', affect_home_team: true, duration: 30, defense_delta: 10, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: 0, morale_delta: 10 },
      { name: 'Butterfingers', description: 'Decreases the opposite team\'s defence, making them more prone to fumbles and dropped balls.', affect_home_team: false, duration: 20, defense_delta: -10, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: 0, morale_delta: 0 },
      { name: 'Snail\'s Pace', description: 'Decreases the opposite team\'s offence, making them slower and less effective at moving the ball down the field.', affect_home_team: false, duration: 3, defense_delta: 0, offense_delta: -10, speed_delta: 0, stamina_delta: 0, health_delta: 0, morale_delta: 0 },
      { name: 'Eagle Eye', description: 'Decreases the opposite team\'s morale, making them more prone to mistakes and bad decisions.', affect_home_team: false, duration: 20, defense_delta: 0, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: 0, morale_delta: -10 },
      { name: 'Fumble-Rooski', description: 'Decreases the opposite team\'s health, making them more prone to injuries and fatigue.', affect_home_team: false, duration: 20, defense_delta: 0, offense_delta: 0, speed_delta: 0, stamina_delta: 0, health_delta: -10, morale_delta: 0 },
      { name: 'Muscle Meltdown', description: 'Decreases the opposite team\'s combined effect, reducing their overall effectiveness on the field.', affect_home_team: false, duration: 20, defense_delta: -10, offense_delta: -10, speed_delta: 0, stamina_delta: 0, health_delta: -10, morale_delta: -10 }
    ].each do |bonus|
      bonus = Bonus.create!(bonus)
      snapshot = Snapshots::Entries::Bonus.new(id: bonus.id,
                                               name: bonus.name,
                                               affect_home_team: bonus.affect_home_team,
                                               duration: bonus.duration,
                                               stats_delta: {
                                                 offense: bonus.offense_delta,
                                                 defense: bonus.defense_delta,
                                                 stamina: bonus.stamina_delta,
                                                 speed: bonus.speed_delta,
                                                 morale: bonus.morale_delta,
                                                 health: bonus.health_delta
                                               })

      recorder.save(snapshot)
    end
  end
end
