# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'ru'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('Каждую секунду')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('Каждые 45 секунд')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('Каждую минуту с 11:00 AM по 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('Каждую минуту')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('Каждую минуту')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('Каждую минуту')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('Каждые 5 минут')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('Каждые 5 минут, в 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('Каждые 5 минут')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('Каждые 10 минут')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('Каждый час')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('Каждый час')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('В 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('В 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('В 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('В 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('В 11:00 PM, понедельник - пятница')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('В 11:30 AM, понедельник - пятница')
      end
    end

    it 'one month only' do
      expect(desc('* * * 3 *')).to eq('Каждую минуту, только март')
    end

    it 'two months only' do
      expect(desc('* * * 3,6 *')).to eq('Каждую минуту, только март и июнь')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('В 2:30 PM и 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('В 6:30 AM, 2:30 PM и 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('В 9:46 AM, только воскресенье')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('В 9:46 AM, только воскресенье')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('В 9:46 AM, только воскресенье')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('В 9:46 AM, только понедельник')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('В 9:46 AM, только суббота')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('В 9:46 AM, только воскресенье')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('В 9:46 AM, только воскресенье')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('В 9:46 AM, только понедельник')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('В 9:46 AM, только суббота')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('В 9:46 AM, только понедельник и вторник')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('В 9:46 AM, только понедельник и вторник')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('В 9:46 AM, только воскресенье и суббота')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('В 9:46 AM, только суббота и воскресенье')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('В 9:46 AM, только воскресенье и понедельник')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('В 9:46 AM, только воскресенье и понедельник')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('В 9:46 AM, только пятница и суббота')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('В 12:23 PM, 15 день месяца')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('В 12:23 PM, 15 день месяца, только воскресенье')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('В 12:23 PM, только январь')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('В 12:23 PM, только январь')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('В 12:23 PM, январь - февраль')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('В 12:23 PM, январь - март')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('В 12:23 PM, только воскресенье')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('Каждые 5 минут, в 3:00 PM, понедельник - пятница')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('Каждые 5 минут, в 3:00 PM, воскресенье - суббота')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('Каждые 5 минут, в 3:00 PM, суббота - воскресенье')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('Каждую минуту, в третий понедельник месяца')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('Каждую минуту, в третий воскресенье месяца')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('Каждую минуту, в последний четверг месяца')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('Каждую минуту, в последний воскресенье месяца')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('Каждые 5 минут, в последний день месяца, только январь')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('Каждые 5 минут, между 23 днем и последним днем месяца, только январь')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('В 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Секунды с 5 по 10')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Секунды с 5 по 10, минуты с 30 по 35, между 10:00 AM и 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('В 30 секунд, каждые 5 минут')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        'В 30 минут часа, между 10:00 AM и 1:59 PM, только среда и пятница')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('В 10 секунд, каждые 5 минут')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'Каждые 3 минут, минуты с 02 по 59, в 1:00 AM, 9:00 AM и 10:00 PM, между 11 днем и 26 днем месяца, январь - июнь')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('В 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('В 05 минут часа')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        'В 00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 и 55 минут часа')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'Каждые 2 минут, минуты с 00 по 30, в 5:00 PM, понедельник - пятница')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('В 7:30 AM, каждые 2 дня(ей), между 1 днем и последним днем месяца')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('Каждую секунду, только 2013')
    end

    it 'one year only without seconds' do
      expect(desc('* * * * * 2013')).to eq('Каждую минуту, только 2013')
    end

    it 'two years only' do
      expect(desc('* * * * * 2013,2014')).to eq('Каждую минуту, только 2013 и 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('В 12:23 PM, январь - февраль, 2013 - 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('В 12:23 PM, январь - март, 2013 - 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Минуты с 02,04 по 05, в 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Минуты с 02,26 по 28, в 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('В 05 и 10 минут часа, в 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('В 05 и 10 минут часа')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('В 05 и 10 минут часа, 2 день месяца')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('Каждые 10 минут, начало в 05 минут часа, 2 день месяца')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('В 5 и 6 секунд, в 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('В 5 и 6 секунд')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('В 5 и 6 секунд, в 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('В 5 и 6 секунд, 2 день месяца')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('Каждые 15 секунд, начало в 5 секунд')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('Каждые 10 минут, начало в 30 минут часа')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('В 30 минут часа, каждые 6 часов, начало в 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('В 8:30 AM, каждые 7 дня(ей), начало 2 день месяца')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('В 11:30 AM, каждые 2 дня(ей) недели, начало в вторник')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('В 10:20 AM, только четверг, каждые 3 месяцев, начало в февраль')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('В 12:00 AM, 1 день месяца, только март, каждые 5 лет, начало в 2010')
      end
    end
  end
end
