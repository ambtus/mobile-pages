class AddAudioUrlToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :audio_url, :string
  end
end
