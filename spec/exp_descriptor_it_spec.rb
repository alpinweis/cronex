# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'it'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('Ogni secondo')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('Ogni 45 secondi')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('Ogni minuto tra le 11:00 AM e le 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('Ogni minuto')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('Ogni minuto')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('Ogni minuto')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minuti' do
        expect(desc('*/5 * * * *')).to eq('Ogni 5 minuti')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('Ogni 5 minuti, alle(ai) 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('Ogni 5 minuti')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('Ogni 10 minuti')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('Ogni ora')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('Ogni ora')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('Alle(ai) 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('Alle(ai) 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('Alle(ai) 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('Alle(ai) 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('Alle(ai) 11:00 PM, da lunedì a venerdì')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('Alle(ai) 11:30 AM, da lunedì a venerdì')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('Ogni minuto, solo a(nel) marzo')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq('Ogni minuto, solo a(nel) marzo e giugno')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('Alle(ai) 2:30 PM e 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('Alle(ai) 6:30 AM, 2:30 PM e 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('Alle(ai) 9:46 AM, solo di domenica')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('Alle(ai) 9:46 AM, solo di domenica')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('Alle(ai) 9:46 AM, solo di domenica')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('Alle(ai) 9:46 AM, solo di lunedì')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('Alle(ai) 9:46 AM, solo di sabato')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('Alle(ai) 9:46 AM, solo di domenica')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('Alle(ai) 9:46 AM, solo di domenica')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('Alle(ai) 9:46 AM, solo di lunedì')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('Alle(ai) 9:46 AM, solo di sabato')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('Alle(ai) 9:46 AM, solo di lunedì e martedì')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('Alle(ai) 9:46 AM, solo di lunedì e martedì')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('Alle(ai) 9:46 AM, solo di domenica e sabato')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('Alle(ai) 9:46 AM, solo di sabato e domenica')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('Alle(ai) 9:46 AM, solo di domenica e lunedì')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('Alle(ai) 9:46 AM, solo di domenica e lunedì')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('Alle(ai) 9:46 AM, solo di venerdì e sabato')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('Alle(ai) 12:23 PM, il giorno 15 del mese')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('Alle(ai) 12:23 PM, il giorno 15 del mese, solo di domenica')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('Alle(ai) 12:23 PM, solo a(nel) gennaio')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('Alle(ai) 12:23 PM, solo a(nel) gennaio')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('Alle(ai) 12:23 PM, da gennaio a febbraio')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('Alle(ai) 12:23 PM, da gennaio a marzo')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('Alle(ai) 12:23 PM, solo di domenica')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('Ogni 5 minuti, alle(ai) 3:00 PM, da lunedì a venerdì')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('Ogni 5 minuti, alle(ai) 3:00 PM, da domenica a sabato')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('Ogni 5 minuti, alle(ai) 3:00 PM, da sabato a domenica')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('Ogni minuto, il(la) terzo(a) lunedì del mese')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('Ogni minuto, il(la) terzo(a) domenica del mese')
      end
    end

    context 'last day of week del mese:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('Ogni minuto, l\'ultimo(a) giovedì del mese')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('Ogni minuto, l\'ultimo(a) domenica del mese')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('Ogni 5 minuti, l\'ultimo giorno del mese, solo a(nel) gennaio')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('Ogni 5 minuti, tra il giorno 23 e il ultimo giorno del mese, solo a(nel) gennaio')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('Alle(ai) 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Dal secondo 5 al 10 dopo il minuto')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Dal secondo 5 al 10 dopo il minuto, dal minuto 30 al 35 dopo l\'ora, tra le 10:00 AM e le 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('A 30 secondi dopo il minuto, ogni 5 minuti')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        'Alle(ai) 30 minuti dopo l\'ora, tra le 10:00 AM e le 1:59 PM, solo di mercoledì e venerdì')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('A 10 secondi dopo il minuto, ogni 5 minuti')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'Ogni 3 minuti, dal minuto 02 al 59 dopo l\'ora, alle(ai) 1:00 AM, 9:00 AM e 10:00 PM, tra il giorno 11 e il 26 del mese, da gennaio a giugno')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('Alle(ai) 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('Alle(ai) 05 minuti dopo l\'ora')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        'Alle(ai) 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 e 55 minuti dopo l\'ora')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'Ogni 2 minuti, dal minuto 00 al 30 dopo l\'ora, alle(ai) 5:00 PM, da lunedì a venerdì')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('Alle(ai) 7:30 AM, ogni 2 giorni, tra il giorno 1 e il ultimo giorno del mese')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('Ogni secondo, solo a(nel) 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('Ogni minuto, solo a(nel) 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('Ogni minuto, solo a(nel) 2013 e 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('Alle(ai) 12:23 PM, da gennaio a febbraio, da 2013 a 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('Alle(ai) 12:23 PM, da gennaio a marzo, da 2013 a 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Dal minuto 02,04 al 05 dopo l\'ora, alle(ai) 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Dal minuto 02,26 al 28 dopo l\'ora, alle(ai) 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('Alle(ai) 05 e 10 minuti dopo l\'ora, alle(ai) 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('Alle(ai) 05 e 10 minuti dopo l\'ora')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('Alle(ai) 05 e 10 minuti dopo l\'ora, il giorno 2 del mese')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('Ogni 10 minuti, a partire da alle(ai) 05 minuti dopo l\'ora, il giorno 2 del mese')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('A 5 e 6 secondi dopo il minuto, alle(ai) 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('A 5 e 6 secondi dopo il minuto')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('A 5 e 6 secondi dopo il minuto, alle(ai) 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('A 5 e 6 secondi dopo il minuto, il giorno 2 del mese')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('Ogni 15 secondi, a partire da a 5 secondi dopo il minuto')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('Ogni 10 minuti, a partire da alle(ai) 30 minuti dopo l\'ora')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('Alle(ai) 30 minuti dopo l\'ora, ogni 6 ore, a partire da alle(ai) 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('Alle(ai) 8:30 AM, ogni 7 giorni, a partire da il giorno 2 del mese')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('Alle(ai) 11:30 AM, 2 giorni alla settimana, a partire da il martedì')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('Alle(ai) 10:20 AM, solo di giovedì, ogni 3 mesi, a partire da febbraio')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('Alle(ai) 12:00 AM, il giorno 1 del mese, solo a(nel) marzo, ogni 5 anni, a partire da 2010')
      end
    end
  end
end
