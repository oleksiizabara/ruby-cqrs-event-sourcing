class CreateUsersPublicViews < ActiveRecord::Migration[7.0]
  def up
    sql = <<~SQL
      CREATE MATERIALIZED VIEW users_public_views AS
        SELECT
          users.uuid AS id,
          users.nickname,
          users.type,
          users.level,
          users.created_at,
          COALESCE(home_team_stats.wins, 0) + COALESCE(away_team_stats.wins, 0) AS wins,
          COALESCE(home_team_stats.loses, 0) + COALESCE(away_team_stats.loses, 0) AS loses,
          COALESCE(home_team_stats.draws, 0) + COALESCE(away_team_stats.draws, 0) AS draws,
          (COALESCE(home_team_stats.wins, 0) + COALESCE(away_team_stats.wins, 0)) * 3 + (COALESCE(home_team_stats.draws, 0) + COALESCE(away_team_stats.draws, 0)) AS points
        FROM
        users
        LEFT JOIN (
          SELECT
            home_team_id AS user_id,
            COUNT(*) FILTER (WHERE home_team_score > away_team_score) AS wins,
            COUNT(*) FILTER (WHERE home_team_score < away_team_score) AS loses,
            COUNT(*) FILTER (WHERE home_team_score = away_team_score) AS draws
          FROM
            games
          WHERE
            end_time IS NOT NULL
          GROUP BY
            home_team_id
        ) AS home_team_stats ON home_team_stats.user_id = users.id
        LEFT JOIN (
          SELECT
            guest_team_id AS user_id,
            COUNT(*) FILTER (WHERE home_team_score < away_team_score) AS wins,
            COUNT(*) FILTER (WHERE home_team_score > away_team_score) AS loses,
            COUNT(*) FILTER (WHERE home_team_score = away_team_score) AS draws
          FROM
            games
          WHERE
            end_time IS NOT NULL
          GROUP BY
            guest_team_id
        ) AS away_team_stats ON away_team_stats.user_id = users.id;

      CREATE UNIQUE INDEX index_users_public_views_on_id ON users_public_views (id);
    SQL

    execute sql
  end

  def down
    sql = <<~SQL
      DROP MATERIALIZED VIEW users_public_views;
    SQL

    execute sql
  end
end
