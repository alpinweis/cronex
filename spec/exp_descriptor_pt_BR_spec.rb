# encoding: utf-8
require 'cronex'

module Cronex
  describe ExpressionDescriptor do

    def desc(expression, opts = {})
      opts[:locale] = 'pt_BR'
      Cronex::ExpressionDescriptor.new(expression, opts).description
    end

    let(:opts) { { zero_based_dow: false } }

    it 'every second' do
      expect(desc('* * * * * *')).to eq('A cada segundo')
    end

    it 'every 45 seconds' do
      expect(desc('*/45 * * * * *')).to eq('A cada 45 segundos')
    end

    it 'minute span' do
      expect(desc('0-10 11 * * *')).to eq('A cada minuto entre 11:00 AM e 11:10 AM')
    end

    context 'every minute' do
      it 'every minute' do
        expect(desc('* * * * *')).to eq('A cada minuto')
      end

      it 'every minute */1' do
        expect(desc('*/1 * * * *')).to eq('A cada minuto')
      end

      it 'every minute 0 0/1' do
        expect(desc('0 0/1 * * * ?')).to eq('A cada minuto')
      end
    end

    context 'every X minutes:' do
      it 'every 5 minutes' do
        expect(desc('*/5 * * * *')).to eq('A cada 5 minutos')
      end

      it 'every 5 minutes at Midnight' do
        expect(desc('*/5 0 * * *')).to eq('A cada 5 minutos, 12:00 AM')
      end

      it 'every 5 minutes 0 */5' do
        expect(desc('0 */5 * * * *')).to eq('A cada 5 minutos')
      end

      it 'every 10 minutes 0 0/10' do
        expect(desc('0 0/10 * * * ?')).to eq('A cada 10 minutos')
      end
    end

    context 'every hour:' do
      it 'every hour 0 0' do
        expect(desc('0 0 * * * ?')).to eq('A cada hora')
      end

      it 'every hour 0 0 0/1' do
        expect(desc('0 0 0/1 * * ?')).to eq('A cada hora')
      end
    end

    context 'daily:' do
      it 'daily at /\d\d/:/\d\d/' do
        expect(desc('30 11 * * *')).to eq('Às 11:30 AM')
      end

      it 'daily at /\d/:/\d/' do
        expect(desc('9 8 * * *')).to eq('Às 8:09 AM')
      end

      it 'daily at /0[89]/:/0[89]/' do
        expect(desc('09 08 * * *')).to eq('Às 8:09 AM')
      end

      it 'daily at /0[1-7]/ /0[1-7/' do
        expect(desc('02 01 * * *')).to eq('Às 1:02 AM')
      end
    end

    context 'time of day certain days of week:' do
      it 'time of day on MON-FRI' do
        expect(desc('0 23 ? * MON-FRI')).to eq('Às 11:00 PM, de segunda-feira a sexta-feira')
      end

      it 'time of day on 1-5' do
        expect(desc('30 11 * * 1-5')).to eq('Às 11:30 AM, de segunda-feira a sexta-feira')
      end
    end

    it 'one month todo(a)' do
      expect(desc('* * * 3 *')).to eq('A cada minuto, em março')
    end

    it 'two months todo(a)' do
      expect(desc('* * * 3,6 *')).to eq('A cada minuto, em março e junho')
    end

    it 'two times each afternoon' do
      expect(desc('30 14,16 * * *')).to eq('Às 2:30 PM e 4:30 PM')
    end

    it 'three times daily' do
      expect(desc('30 6,14,16 * * *')).to eq('Às 6:30 AM, 2:30 PM e 4:30 PM')
    end

    context 'once a week:' do
      it 'once a week 0' do
        expect(desc('46 9 * * 0')).to eq('Às 9:46 AM, todo(a) domingo')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN')).to eq('Às 9:46 AM, todo(a) domingo')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7')).to eq('Às 9:46 AM, todo(a) domingo')
      end

      it 'once a week 1' do
        expect(desc('46 9 * * 1')).to eq('Às 9:46 AM, todo(a) segunda-feira')
      end

      it 'once a week 6' do
        expect(desc('46 9 * * 6')).to eq('Às 9:46 AM, todo(a) sábado')
      end
    end

    context 'once a week non zero based:' do
      it 'once a week 1' do
        expect(desc('46 9 * * 1', opts)).to eq('Às 9:46 AM, todo(a) domingo')
      end

      it 'once a week SUN' do
        expect(desc('46 9 * * SUN', opts)).to eq('Às 9:46 AM, todo(a) domingo')
      end

      it 'once a week 2' do
        expect(desc('46 9 * * 2', opts)).to eq('Às 9:46 AM, todo(a) segunda-feira')
      end

      it 'once a week 7' do
        expect(desc('46 9 * * 7', opts)).to eq('Às 9:46 AM, todo(a) sábado')
      end
    end

    context 'twice a week:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2')).to eq('Às 9:46 AM, todo(a) segunda-feira e terça-feira')
      end

      it 'twice a week MON,TUE' do
        expect(desc('46 9 * * MON,TUE')).to eq('Às 9:46 AM, todo(a) segunda-feira e terça-feira')
      end

      it 'twice a week 0,6' do
        expect(desc('46 9 * * 0,6')).to eq('Às 9:46 AM, todo(a) domingo e sábado')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7')).to eq('Às 9:46 AM, todo(a) sábado e domingo')
      end
    end

    context 'twice a week non zero based:' do
      it 'twice a week 1,2' do
        expect(desc('46 9 * * 1,2', opts)).to eq('Às 9:46 AM, todo(a) domingo e segunda-feira')
      end

      it 'twice a week SUN,MON' do
        expect(desc('46 9 * * SUN,MON', opts)).to eq('Às 9:46 AM, todo(a) domingo e segunda-feira')
      end

      it 'twice a week 6,7' do
        expect(desc('46 9 * * 6,7', opts)).to eq('Às 9:46 AM, todo(a) sexta-feira e sábado')
      end
    end

    it 'day of month' do
      expect(desc('23 12 15 * *')).to eq('Às 12:23 PM, no dia 15 do mês')
    end

    it 'day of month with day of week' do
      expect(desc('23 12 15 * SUN')).to eq('Às 12:23 PM, no dia 15 do mês, todo(a) domingo')
    end

    it 'month name' do
      expect(desc('23 12 * JAN *')).to eq('Às 12:23 PM, em janeiro')
    end

    it 'day of month with question mark' do
      expect(desc('23 12 ? JAN *')).to eq('Às 12:23 PM, em janeiro')
    end

    it 'month name range 2' do
      expect(desc('23 12 * JAN-FEB *')).to eq('Às 12:23 PM, de janeiro a fevereiro')
    end

    it 'month name range 3' do
      expect(desc('23 12 * JAN-MAR *')).to eq('Às 12:23 PM, de janeiro a março')
    end

    it 'day of week name' do
      expect(desc('23 12 * * SUN')).to eq('Às 12:23 PM, todo(a) domingo')
    end

    context 'day of week range:' do
      it 'day of week range MON-FRI' do
        expect(desc('*/5 15 * * MON-FRI')).to eq('A cada 5 minutos, 3:00 PM, de segunda-feira a sexta-feira')
      end

      it 'day of week range 0-6' do
        expect(desc('*/5 15 * * 0-6')).to eq('A cada 5 minutos, 3:00 PM, de domingo a sábado')
      end

      it 'day of week range 6-7' do
        expect(desc('*/5 15 * * 6-7')).to eq('A cada 5 minutos, 3:00 PM, de sábado a domingo')
      end
    end

    context 'day of week once in month:' do
      it 'day of week once MON#3' do
        expect(desc('* * * * MON#3')).to eq('A cada minuto, no(a) terceiro(a) segunda-feira do mês')
      end

      it 'day of week once 0#3' do
        expect(desc('* * * * 0#3')).to eq('A cada minuto, no(a) terceiro(a) domingo do mês')
      end
    end

    context 'last day of week of the month:' do
      it 'last day of week 4L' do
        expect(desc('* * * * 4L')).to eq('A cada minuto, no(a) último(a) quinta-feira do mês')
      end

      it 'last day of week 0L' do
        expect(desc('* * * * 0L')).to eq('A cada minuto, no(a) último(a) domingo do mês')
      end
    end

    context 'last day of the month:' do
      it 'on the last day of the month' do
        expect(desc('*/5 * L JAN *')).to eq('A cada 5 minutos, no último dia do mês, em janeiro')
      end

      it 'between a day and last day of the month' do
        expect(desc('*/5 * 23-L JAN *')).to eq('A cada 5 minutos, entre os dias 23 e último dia do mês, em janeiro')
      end
    end

    it 'time of day with seconds' do
      expect(desc('30 02 14 * * *')).to eq('Às 2:02:30 PM')
    end

    it 'second intervals' do
      expect(desc('5-10 * * * * *')).to eq('Entre 5 e 10 segundos após o minuto')
    end

    it 'second minutes hours intervals' do
      expect(desc('5-10 30-35 10-12 * * *')).to eq(
        'Entre 5 e 10 segundos após o minuto, entre 30 e 35 minutos após a hora, entre 10:00 AM e 12:59 PM')
    end

    it 'every 5 minutes at 30 seconds' do
      expect(desc('30 */5 * * * *')).to eq('30 segundos após o minuto, a cada 5 minutos')
    end

    it 'minutes past the hour range' do
      expect(desc('0 30 10-13 ? * WED,FRI')).to eq(
        '30 minutos após a hora, entre 10:00 AM e 1:59 PM, todo(a) quarta-feira e sexta-feira')
    end

    it 'seconds past the minute interval' do
      expect(desc('10 0/5 * * * ?')).to eq('10 segundos após o minuto, a cada 5 minutos')
    end

    it 'between with interval' do
      expect(desc('2-59/3 1,9,22 11-26 1-6 ?')).to eq(
        'A cada 3 minutos, entre 02 e 59 minutos após a hora, 1:00 AM, 9:00 AM e 10:00 PM, entre os dias 11 e 26 do mês, de janeiro a junho')
    end

    it 'recurring first of month' do
      expect(desc('0 0 6 1/1 * ?')).to eq('Às 6:00 AM')
    end

    it 'minutes past the hour' do
      expect(desc('0 5 0/1 * * ?')).to eq('05 minutos após a hora')
    end

    it 'every past the hour' do
      expect(desc('0 0,5,10,15,20,25,30,35,40,45,50,55 * ? * *')).to eq(
        '00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50 e 55 minutos após a hora')
    end

    it 'every X minutes past the hour with interval' do
      expect(desc('0 0-30/2 17 ? * MON-FRI')).to eq(
        'A cada 2 minutos, entre 00 e 30 minutos após a hora, 5:00 PM, de segunda-feira a sexta-feira')
    end

    it 'every X days with interval' do
      expect(desc('30 7 1-L/2 * *')).to eq('Às 7:30 AM, a cada 2 dias, entre os dias 1 e último dia do mês')
    end

    it 'one year only with seconds' do
      expect(desc('* * * * * * 2013')).to eq('A cada segundo, em 2013')
    end

    it 'one year todo(a) without seconds' do
      expect(desc('* * * * * 2013')).to eq('A cada minuto, em 2013')
    end

    it 'two years todo(a)' do
      expect(desc('* * * * * 2013,2014')).to eq('A cada minuto, em 2013 e 2014')
    end

    it 'year range 2' do
      expect(desc('23 12 * JAN-FEB * 2013-2014')).to eq('Às 12:23 PM, de janeiro a fevereiro, de 2013 a 2014')
    end

    it 'year range 3' do
      expect(desc('23 12 * JAN-MAR * 2013-2015')).to eq('Às 12:23 PM, de janeiro a março, de 2013 a 2015')
    end

    context 'multi part range seconds:' do
      it 'multi part range seconds 2,4-5' do
        expect(desc('2,4-5 1 * * *')).to eq('Entre 02,04 e 05 minutos após a hora, 1:00 AM')
      end

      it 'multi part range seconds 2,26-28' do
        expect(desc('2,26-28 18 * * *')).to eq('Entre 02,26 e 28 minutos após a hora, 6:00 PM')
      end
    end

    context 'minutes past the hour:' do
      it 'minutes past the hour 5,10, midnight hour' do
        expect(desc('5,10 0 * * *')).to eq('05 e 10 minutos após a hora, 12:00 AM')
      end

      it 'minutes past the hour 5,10' do
        expect(desc('5,10 * * * *')).to eq('05 e 10 minutos após a hora')
      end

      it 'minutes past the hour 5,10 day 2' do
        expect(desc('5,10 * 2 * *')).to eq('05 e 10 minutos após a hora, no dia 2 do mês')
      end

      it 'minutes past the hour 5/10 day 2' do
        expect(desc('5/10 * 2 * *')).to eq('A cada 10 minutos, iniciando 05 minutos após a hora, no dia 2 do mês')
      end
    end

    context 'seconds past the minute:' do
      it 'seconds past the minute 5,6, midnight hour' do
        expect(desc('5,6 0 0 * * *')).to eq('5 e 6 segundos após o minuto, 12:00 AM')
      end

      it 'seconds past the minute 5,6' do
        expect(desc('5,6 0 * * * *')).to eq('5 e 6 segundos após o minuto')
      end

      it 'seconds past the minute 5,6 at 1' do
        expect(desc('5,6 0 1 * * *')).to eq('5 e 6 segundos após o minuto, 1:00 AM')
      end

      it 'seconds past the minute 5,6 day 2' do
        expect(desc('5,6 0 * 2 * *')).to eq('5 e 6 segundos após o minuto, no dia 2 do mês')
      end
    end

    context 'increments starting at X > 1:' do
      it 'second increments' do
        expect(desc('5/15 0 * * * *')).to eq('A cada 15 segundos, iniciando 5 segundos após o minuto')
      end

      it 'minute increments' do
        expect(desc('30/10 * * * *')).to eq('A cada 10 minutos, iniciando 30 minutos após a hora')
      end

      it 'hour increments' do
        expect(desc('0 30 2/6 * * ?')).to eq('30 minutos após a hora, a cada 6 horas, iniciando 2:00 AM')
      end

      it 'day of month increments' do
        expect(desc('0 30 8 2/7 * *')).to eq('Às 8:30 AM, a cada 7 dias, iniciando no dia 2 do mês')
      end

      it 'day of week increments' do
        expect(desc('0 30 11 * * 2/2')).to eq('Às 11:30 AM, a cada 2 dias da semana, iniciando terça-feira')
      end

      it 'month increments' do
        expect(desc('0 20 10 * 2/3 THU')).to eq('Às 10:20 AM, todo(a) quinta-feira, a cada 3 mêses, iniciando em fevereiro')
      end

      it 'year increments' do
        expect(desc('0 0 0 1 MAR * 2010/5')).to eq('Às 12:00 AM, no dia 1 do mês, em março, a cada 5 anos, iniciando em 2010')
      end
    end
  end
end
