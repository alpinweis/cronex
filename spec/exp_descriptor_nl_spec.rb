# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'nl'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('Elke seconde')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('Elke 45 seconden')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('Elke minuut tussen 11:00 AM en 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('Elke minuut')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('Elke minuut')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('Elke minuut')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('Elke 5 minuten')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('Elke 5 minuten, om 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('Elke 5 minuten')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('Elke 10 minuten')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('Elk uur')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('Elk uur')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('Om 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('Om 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('Om 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('Om 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('Om 11:00 PM, maandag tot en met vrijdag')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('Om 11:30 AM, maandag tot en met vrijdag')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('Elke minuut, alleen in maart')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq('Elke minuut, alleen in maart en juni')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('Om 2:30 PM en 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('Om 6:30 AM, 2:30 PM en 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('Om 9:46 AM, alleen op zondag')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('Om 9:46 AM, alleen op zondag')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('Om 9:46 AM, alleen op zondag')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('Om 9:46 AM, alleen op maandag')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('Om 9:46 AM, alleen op zaterdag')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('Om 9:46 AM, alleen op zondag')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('Om 9:46 AM, alleen op zondag')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('Om 9:46 AM, alleen op maandag')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('Om 9:46 AM, alleen op zaterdag')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('Om 9:46 AM, alleen op maandag en dinsdag')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('Om 9:46 AM, alleen op maandag en dinsdag')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('Om 9:46 AM, alleen op zondag en zaterdag')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('Om 9:46 AM, alleen op zaterdag en zondag')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('Om 9:46 AM, alleen op zondag en maandag')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('Om 9:46 AM, alleen op zondag en maandag')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('Om 9:46 AM, alleen op vrijdag en zaterdag')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('Om 12:23 PM, op dag 15 van de maand')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('Om 12:23 PM, op dag 15 van de maand, alleen op zondag')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('Om 12:23 PM, alleen in januari')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('Om 12:23 PM, alleen in januari')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('Om 12:23 PM, januari tot en met februari')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('Om 12:23 PM, januari tot en met maart')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('Om 12:23 PM, alleen op zondag')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('Elke 5 minuten, om 3:00 PM, maandag tot en met vrijdag')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('Elke 5 minuten, om 3:00 PM, zondag tot en met zaterdag')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('Elke 5 minuten, om 3:00 PM, zaterdag tot en met zondag')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('Elke minuut, op de derde maandag van de maand')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('Elke minuut, op de derde zondag van de maand')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('Elke minuut, op de laatste donderdag van de maand')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('Elke minuut, op de laatste zondag van de maand')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('Elke 5 minuten, op de laatste dag van de maand, alleen in januari')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('Elke 5 minuten, tussen dag 23 en de laatste dag van de maand, alleen in januari')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('Om 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Seconden 5 tot en met 10 na de minuut')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Seconden 5 tot en met 10 na de minuut, minuten 30 tot en met 35 na het uur, tussen 10:00 AM en 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('Op 30 seconden na de minuut, elke 5 minuten')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        'Om 30 minuten na het uur, tussen 10:00 AM en 1:59 PM, alleen op woensdag en vrijdag')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('Op 10 seconden na de minuut, elke 5 minuten')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'Elke 3 minuten, minuten 02 tot en met 59 na het uur, om 1:00 AM, 9:00 AM en 10:00 PM, tussen dag 11 en 26 van de maand, januari tot en met juni')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('Om 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('Om 05 minuten na het uur')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        'Om 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 en 55 minuten na het uur')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'Elke 2 minuten, minuten 00 tot en met 30 na het uur, om 5:00 PM, maandag tot en met vrijdag')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('Om 7:30 AM, elke 2 dagen, tussen dag 1 en de laatste dag van de maand')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('Elke seconde, alleen in 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('Elke minuut, alleen in 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('Elke minuut, alleen in 2013 en 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('Om 12:23 PM, januari tot en met februari, 2013 tot en met 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('Om 12:23 PM, januari tot en met maart, 2013 tot en met 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Minuten 02,04 tot en met 05 na het uur, om 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Minuten 02,26 tot en met 28 na het uur, om 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('Om 05 en 10 minuten na het uur, om 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('Om 05 en 10 minuten na het uur')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('Om 05 en 10 minuten na het uur, op dag 2 van de maand')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('Elke 10 minuten, beginnend om 05 minuten na het uur, op dag 2 van de maand')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('Op 5 en 6 seconden na de minuut, om 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('Op 5 en 6 seconden na de minuut')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('Op 5 en 6 seconden na de minuut, om 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('Op 5 en 6 seconden na de minuut, op dag 2 van de maand')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('Elke 15 seconden, beginnend op 5 seconden na de minuut')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('Elke 10 minuten, beginnend om 30 minuten na het uur')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('Om 30 minuten na het uur, elke 6 uren, beginnend om 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('Om 8:30 AM, elke 7 dagen, beginnend op dag 2 van de maand')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('Om 11:30 AM, elke 2 dagen van de week, beginnend op dinsdag')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('Om 10:20 AM, alleen op donderdag, elke 3 maanden, beginnend in februari')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('Om 12:00 AM, op dag 1 van de maand, alleen in maart, elke 5 jaren, beginnend in 2010')
      end
    end
  end
end
