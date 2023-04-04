class Map < ApplicationRecord
    geocoded_by :address # 住所を指定
    after_validation :geocode # バリデーション後に緯度経度を取得
  
    # 緯度・経度が両方存在する場合に真を返す
    def has_coordinates?
      latitude.present? && longitude.present?
    end
end
