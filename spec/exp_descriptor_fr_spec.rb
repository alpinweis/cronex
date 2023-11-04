# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'fr'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('Chaque seconde')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('Toutes les 45 secondes')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('Chaque minute entre 11:00 AM et 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('Chaque minute')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('Chaque minute')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('Chaque minute')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('Tous les 5 minutes')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('Tous les 5 minutes, à 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('Tous les 5 minutes')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('Tous les 10 minutes')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('Chaque heure')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('Chaque heure')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('À 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('À 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('À 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('À 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('À 11:00 PM, lundi à vendredi')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('À 11:30 AM, lundi à vendredi')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('Chaque minute, seulement en mars')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq("Chaque minute, seulement en mars et juin")
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq("À 2:30 PM et 4:30 PM")
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('À 6:30 AM, 2:30 PM et 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('À 9:46 AM, seulement le dimanche')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('À 9:46 AM, seulement le dimanche')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('À 9:46 AM, seulement le dimanche')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('À 9:46 AM, seulement le lundi')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('À 9:46 AM, seulement le samedi')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('À 9:46 AM, seulement le dimanche')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('À 9:46 AM, seulement le dimanche')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('À 9:46 AM, seulement le lundi')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('À 9:46 AM, seulement le samedi')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('À 9:46 AM, seulement le lundi et mardi')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('À 9:46 AM, seulement le lundi et mardi')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('À 9:46 AM, seulement le dimanche et samedi')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('À 9:46 AM, seulement le samedi et dimanche')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('À 9:46 AM, seulement le dimanche et lundi')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('À 9:46 AM, seulement le dimanche et lundi')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('À 9:46 AM, seulement le vendredi et samedi')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('À 12:23 PM, le 15 de chaque mois')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('À 12:23 PM, le 15 de chaque mois, seulement le dimanche')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('À 12:23 PM, seulement en janvier')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('À 12:23 PM, seulement en janvier')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('À 12:23 PM, janvier à février')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('À 12:23 PM, janvier à mars')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('À 12:23 PM, seulement le dimanche')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('Tous les 5 minutes, à 3:00 PM, lundi à vendredi')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('Tous les 5 minutes, à 3:00 PM, dimanche à samedi')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('Tous les 5 minutes, à 3:00 PM, samedi à dimanche')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('Chaque minute, le troisième lundi du mois')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('Chaque minute, le troisième dimanche du mois')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('Chaque minute, le dernier jeudi du mois')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('Chaque minute, le dernier dimanche du mois')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('Tous les 5 minutes, le dernier jour du mois, seulement en janvier')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('Tous les 5 minutes, entre le jour 23 et le dernier jour du mois, seulement en janvier')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('À 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Secondes 5 à 10 après la minute')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        "Secondes 5 à 10 après la minute, minutes 30 à 35 après l'heure, entre 10:00 AM et 12:59 PM")
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('À 30 secondes après la minute, tous les 5 minutes')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        "À 30 minutes après l'heure, entre 10:00 AM et 1:59 PM, seulement le mercredi et vendredi")
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('À 10 secondes après la minute, tous les 5 minutes')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        "Tous les 3 minutes, minutes 02 à 59 après l'heure, à 1:00 AM, 9:00 AM et 10:00 PM, entre le jour 11 et le 26 du mois, janvier à juin")
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('À 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq("À 05 minutes après l'heure")
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        "À 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 et 55 minutes après l'heure")
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        "Tous les 2 minutes, minutes 00 à 30 après l'heure, à 5:00 PM, lundi à vendredi")
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('À 7:30 AM, tous les 2 jours, entre le jour 1 et le dernier jour du mois')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('Chaque seconde, seulement en 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('Chaque minute, seulement en 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('Chaque minute, seulement en 2013 et 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('À 12:23 PM, janvier à février, 2013 à 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('À 12:23 PM, janvier à mars, 2013 à 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq("Minutes 02,04 à 05 après l'heure, à 1:00 AM")
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq("Minutes 02,26 à 28 après l'heure, à 6:00 PM")
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq("À 05 et 10 minutes après l'heure, à 12:00 AM")
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq("À 05 et 10 minutes après l'heure")
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq("À 05 et 10 minutes après l'heure, le 2 de chaque mois")
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq("Tous les 10 minutes, commence à 05 minutes après l'heure, le 2 de chaque mois")
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('À 5 et 6 secondes après la minute, à 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('À 5 et 6 secondes après la minute')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('À 5 et 6 secondes après la minute, à 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('À 5 et 6 secondes après la minute, le 2 de chaque mois')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq("Toutes les 15 secondes, commence à 5 secondes après la minute")
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq("Tous les 10 minutes, commence à 30 minutes après l'heure")
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq("À 30 minutes après l'heure, tous les 6 heures, commence à 2:00 AM")
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('À 8:30 AM, tous les 7 jours, commence le 2 de chaque mois')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('À 11:30 AM, tous les 2 jours de la semaine, commence le mardi')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('À 10:20 AM, seulement le jeudi, tous les 3 mois, commence en février')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('À 12:00 AM, le 1 de chaque mois, seulement en mars, tous les 5 ans, commence en 2010')
      end
    end
  end
end
