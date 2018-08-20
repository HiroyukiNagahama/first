class Prefecture < ApplicationRecord

  AREAS = [
    { name: '北海道地方', code: '01' },
    { name: '北東北地方', code: '02' },
    { name: '南東北地方', code: '03' },
    { name: '北関東地方', code: '04' },
    { name: '南関東地方', code: '05' },
    { name: '北陸地方', code: '06' },
    { name: '甲信越地方', code: '07' },
    { name: '北近畿地方', code: '08' },
    { name: '南近畿地方', code: '09' },
    { name: '東中国地方', code: '10' },
    { name: '西中国地方', code: '11' },
    { name: '四国地方', code: '12' },
    { name: '北九州地方', code: '13' },
    { name: '南九州地方', code: '14' }
  ].freeze

end
