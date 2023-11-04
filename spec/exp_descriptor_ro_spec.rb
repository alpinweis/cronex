# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'ro'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('În fiecare secundă')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('La fiecare 45 secunde')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('În fiecare minut între 11:00 AM și 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('În fiecare minut')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('În fiecare minut')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('În fiecare minut')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('La fiecare 5 minute')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('La fiecare 5 minute, la 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('La fiecare 5 minute')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('La fiecare 10 minute')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('În fiecare oră')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('În fiecare oră')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('La 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('La 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('La 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('La 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('La 11:00 PM, de luni până vineri')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('La 11:30 AM, de luni până vineri')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('În fiecare minut, numai în martie')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq('În fiecare minut, numai în martie și iunie')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('La 2:30 PM și 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('La 6:30 AM, 2:30 PM și 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('La 9:46 AM, numai duminică')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('La 9:46 AM, numai duminică')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('La 9:46 AM, numai duminică')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('La 9:46 AM, numai luni')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('La 9:46 AM, numai sâmbătă')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('La 9:46 AM, numai duminică')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('La 9:46 AM, numai duminică')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('La 9:46 AM, numai luni')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('La 9:46 AM, numai sâmbătă')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('La 9:46 AM, numai luni și marți')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('La 9:46 AM, numai luni și marți')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('La 9:46 AM, numai duminică și sâmbătă')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('La 9:46 AM, numai sâmbătă și duminică')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('La 9:46 AM, numai duminică și luni')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('La 9:46 AM, numai duminică și luni')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('La 9:46 AM, numai vineri și sâmbătă')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('La 12:23 PM, în a 15-a zi a lunii')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('La 12:23 PM, în a 15-a zi a lunii, numai duminică')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('La 12:23 PM, numai în ianuarie')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('La 12:23 PM, numai în ianuarie')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('La 12:23 PM, din ianuarie până în februarie')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('La 12:23 PM, din ianuarie până în martie')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('La 12:23 PM, numai duminică')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('La fiecare 5 minute, la 3:00 PM, de luni până vineri')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('La fiecare 5 minute, la 3:00 PM, de duminică până sâmbătă')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('La fiecare 5 minute, la 3:00 PM, de sâmbătă până duminică')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('În fiecare minut, în a treia luni a lunii')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('În fiecare minut, în a treia duminică a lunii')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('În fiecare minut, în ultima joi din lună')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('În fiecare minut, în ultima duminică din lună')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('La fiecare 5 minute, în ultima zi a lunii, numai în ianuarie')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('La fiecare 5 minute, între zilele 23 și ultima zi a lunii, numai în ianuarie')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('La 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Între secundele 5 și 10')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Între secundele 5 și 10, între minutele 30 și 35, între 10:00 AM și 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('La secunda 30, la fiecare 5 minute')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        'La 30 minute în fiecare oră, între 10:00 AM și 1:59 PM, numai miercuri și vineri')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('La secunda 10, la fiecare 5 minute')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'La fiecare 3 minute, între minutele 02 și 59, la 1:00 AM, 9:00 AM și 10:00 PM, între zilele 11 și 26 a lunii, din ianuarie până în iunie')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('La 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('La 05 minute în fiecare oră')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        'La 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 și 55 minute în fiecare oră')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'La fiecare 2 minute, între minutele 00 și 30, la 5:00 PM, de luni până vineri')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('La 7:30 AM, la fiecare 2 zile, între zilele 1 și ultima zi a lunii')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('În fiecare secundă, numai în 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('În fiecare minut, numai în 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('În fiecare minut, numai în 2013 și 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('La 12:23 PM, din ianuarie până în februarie, din 2013 până în 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('La 12:23 PM, din ianuarie până în martie, din 2013 până în 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Între minutele 02,04 și 05, la 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Între minutele 02,26 și 28, la 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('La 05 și 10 minute în fiecare oră, la 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('La 05 și 10 minute în fiecare oră')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('La 05 și 10 minute în fiecare oră, în a 2-a zi a lunii')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('La fiecare 10 minute, pornire la 05 minute în fiecare oră, în a 2-a zi a lunii')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('La secunda 5 și 6, la 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('La secunda 5 și 6')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('La secunda 5 și 6, la 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('La secunda 5 și 6, în a 2-a zi a lunii')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('La fiecare 15 secunde, pornire la secunda 5')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('La fiecare 10 minute, pornire la 30 minute în fiecare oră')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('La 30 minute în fiecare oră, la fiecare 6 ore, pornire la 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('La 8:30 AM, la fiecare 7 zile, pornire în a 2-a zi a lunii')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('La 11:30 AM, în fiecare 2 zile din săptămână, pornire de marți')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('La 10:20 AM, numai joi, la fiecare 3 luni, pornire în februarie')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('La 12:00 AM, în a 1-a zi a lunii, numai în martie, la fiecare 5 ani, pornire în 2010')
      end
    end
  end
end
