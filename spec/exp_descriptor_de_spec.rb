# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'de'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('Jede Sekunde')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('Alle 45 Sekunden')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('Jede Minute zwischen 11:00 AM und 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('Jede Minute')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('Jede Minute')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('Jede Minute')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('Alle 5 Minuten')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('Alle 5 Minuten, um 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('Alle 5 Minuten')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('Alle 10 Minuten')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('Jede Stunde')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('Jede Stunde')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('Um 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('Um 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('Um 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('Um 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('Um 11:00 PM, Montag bis Freitag')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('Um 11:30 AM, Montag bis Freitag')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('Jede Minute, nur in März')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq('Jede Minute, nur in März und Juni')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('Um 2:30 PM und 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('Um 6:30 AM, 2:30 PM und 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('Um 9:46 AM, nur an Sonntag')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('Um 9:46 AM, nur an Sonntag')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('Um 9:46 AM, nur an Sonntag')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('Um 9:46 AM, nur an Montag')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('Um 9:46 AM, nur an Samstag')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('Um 9:46 AM, nur an Sonntag')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('Um 9:46 AM, nur an Sonntag')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('Um 9:46 AM, nur an Montag')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('Um 9:46 AM, nur an Samstag')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('Um 9:46 AM, nur an Montag und Dienstag')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('Um 9:46 AM, nur an Montag und Dienstag')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('Um 9:46 AM, nur an Sonntag und Samstag')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('Um 9:46 AM, nur an Samstag und Sonntag')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('Um 9:46 AM, nur an Sonntag und Montag')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('Um 9:46 AM, nur an Sonntag und Montag')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('Um 9:46 AM, nur an Freitag und Samstag')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('Um 12:23 PM, am 15 Tag des Monats')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('Um 12:23 PM, am 15 Tag des Monats, nur an Sonntag')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('Um 12:23 PM, nur in Januar')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('Um 12:23 PM, nur in Januar')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('Um 12:23 PM, Januar bis Februar')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('Um 12:23 PM, Januar bis März')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('Um 12:23 PM, nur an Sonntag')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('Alle 5 Minuten, um 3:00 PM, Montag bis Freitag')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('Alle 5 Minuten, um 3:00 PM, Sonntag bis Samstag')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('Alle 5 Minuten, um 3:00 PM, Samstag bis Sonntag')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('Jede Minute, am dritten Montag des Monats')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('Jede Minute, am dritten Sonntag des Monats')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('Jede Minute, am letzten Donnerstag des Monats')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('Jede Minute, am letzten Sonntag des Monats')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('Alle 5 Minuten, am letzten Tag des Monats, nur in Januar')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('Alle 5 Minuten, zwischen Tag 23 und der letzte Tag des Monats, nur in Januar')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('Um 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Sekunden 5 bis 10 vergangene Minute')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Sekunden 5 bis 10 vergangene Minute, Minuten 30 bis 35 nach der vergangenen Stunde, zwischen 10:00 AM und 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('Am 30 Sekunden nach der vergangenen Minute, Alle 5 Minuten')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        'Um 30 Minuten vergangene Stunde, zwischen 10:00 AM und 1:59 PM, nur an Mittwoch und Freitag')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('Am 10 Sekunden nach der vergangenen Minute, Alle 5 Minuten')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'Alle 3 Minuten, Minuten 02 bis 59 nach der vergangenen Stunde, um 1:00 AM, 9:00 AM und 10:00 PM, zwischen Tag 11 und 26 des Monats, Januar bis Juni')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('Um 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('Um 05 Minuten vergangene Stunde')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        'Um 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 und 55 Minuten vergangene Stunde')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'Alle 2 Minuten, Minuten 00 bis 30 nach der vergangenen Stunde, um 5:00 PM, Montag bis Freitag')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('Um 7:30 AM, Alle 2 Tagen, zwischen Tag 1 und der letzte Tag des Monats')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('Jede Sekunde, nur in 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('Jede Minute, nur in 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('Jede Minute, nur in 2013 und 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('Um 12:23 PM, Januar bis Februar, 2013 bis 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('Um 12:23 PM, Januar bis März, 2013 bis 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Minuten 02,04 bis 05 nach der vergangenen Stunde, um 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Minuten 02,26 bis 28 nach der vergangenen Stunde, um 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('Um 05 und 10 Minuten vergangene Stunde, um 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('Um 05 und 10 Minuten vergangene Stunde')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('Um 05 und 10 Minuten vergangene Stunde, am 2 Tag des Monats')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('Alle 10 Minuten, beginnend um 05 Minuten vergangene Stunde, am 2 Tag des Monats')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('Am 5 und 6 Sekunden nach der vergangenen Minute, um 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('Am 5 und 6 Sekunden nach der vergangenen Minute')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('Am 5 und 6 Sekunden nach der vergangenen Minute, um 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('Am 5 und 6 Sekunden nach der vergangenen Minute, am 2 Tag des Monats')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('Alle 15 Sekunden, beginnend am 5 Sekunden nach der vergangenen Minute')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('Alle 10 Minuten, beginnend um 30 Minuten vergangene Stunde')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('Um 30 Minuten vergangene Stunde, Alle 6 Stunden, beginnend um 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('Um 8:30 AM, Alle 7 Tagen, beginnend am 2 Tag des Monats')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('Um 11:30 AM, jeden 2 Tag der Woche, beginnend an Dienstag')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('Um 10:20 AM, nur an Donnerstag, Alle 3 Monaten, beginnend in Februar')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('Um 12:00 AM, am 1 Tag des Monats, nur in März, Alle 5 Jahren, beginnend in 2010')
      end
    end
  end
end
