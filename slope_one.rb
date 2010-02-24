# Python version: Copyright 2006 Bryan O'Sullivan <bos@serpentine.com>.
#
# Ruby transcription: Karl Eklund <localpart@gmail.com>, 2008.
#
# This software may be used and distributed according to the terms
# of the GNU General Public License, version 2 or later, which is
# incorporated herein by reference.
#
# The Python original is commented out, and kept for reference:
#
# class SlopeOne(object):
#     def __init__(self):
#         self.diffs = {}
#         self.freqs = {}

class SlopeOne
  def initialize
    @diffs = Hash.new { |hash, key| hash[key] = Hash.new(0.0) }
    @freqs = Hash.new { |hash, key| hash[key] = Hash.new(0) }
  end
  
  #     def predict(self, userprefs):
  #         preds, freqs = {}, {}
  #         for item, rating in userprefs.iteritems():
  #             for diffitem, diffratings in self.diffs.iteritems():
  #                 try:
  #                     freq = self.freqs[diffitem][item]
  #                 except KeyError:
  #                     continue
  #                 preds.setdefault(diffitem, 0.0)
  #                 freqs.setdefault(diffitem, 0)
  #                 preds[diffitem] += freq * (diffratings[item] + rating)
  #                 freqs[diffitem] += freq
  #         return dict([(item, value / freqs[item])
  #                      for item, value in preds.iteritems()
  #                      if item not in userprefs and freqs[item] > 0])

  def predict(userprefs)
    preds = Hash.new(0.0)
    freqs = Hash.new(0)
    result = {}
    for item, rating in userprefs
      for diffitem, diffratings in @diffs
        freq = @freqs[diffitem][item]
        preds[diffitem] += freq * (diffratings[item] + rating)
        freqs[diffitem] += freq
      end
    end
    for item, value in preds
      if not userprefs[item] and freqs[item] > 0
        result[item] = value / freqs[item]
      end
    end
    result
  end

  #     def update(self, userdata):
  #         for ratings in userdata.itervalues():
  #             for item1, rating1 in ratings.iteritems():
  #                 self.freqs.setdefault(item1, {})
  #                 self.diffs.setdefault(item1, {})
  #                 for item2, rating2 in ratings.iteritems():
  #                     self.freqs[item1].setdefault(item2, 0)
  #                     self.diffs[item1].setdefault(item2, 0.0)
  #                     self.freqs[item1][item2] += 1
  #                     self.diffs[item1][item2] += rating1 - rating2
  #         for item1, ratings in self.diffs.iteritems():
  #             for item2 in ratings:
  #                 ratings[item2] /= self.freqs[item1][item2]

  def update(userdata)
    for ratings in userdata.values
      for item1, rating1 in ratings
        for item2, rating2 in ratings
          @freqs[item1][item2] += 1
          @diffs[item1][item2] += rating1 - rating2
        end
      end
    end
    for item1, ratings in @diffs
      for item2 in ratings.keys
        ratings[item2] /= @freqs[item1][item2]
      end
    end
  end
end

# # Python test data:
#
# if __name__ == '__main__':
#     userdata = dict(
#         alice=dict(squid=1.0,
#                    cuttlefish=0.5,
#                    octopus=0.2),
#         bob=dict(squid=1.0,
#                  octopus=0.5,
#                  nautilus=0.2),
#         carole=dict(squid=0.2,
#                     octopus=1.0,
#                     cuttlefish=0.4,
#                     nautilus=0.4),
#         dave=dict(cuttlefish=0.9,
#                   octopus=0.4,
#                   nautilus=0.5),
#         )
# 
# # Python test case, should output 
#
# # {'nautilus': 0.099999999999999978, 'octopus': 0.23333333333333336, 'cuttlefish': 0.25}
# 
# #     s = SlopeOne()
# #     s.update(userdata)
# #     print s.predict(dict(squid=0.4))

# Ruby test data:

if __FILE__ == $0
  userdata = { 
    :alice => { 
        :squid => 1.0,
        :cuttlefish => 0.5,
        :octopus => 0.2 },
    :bob => {
      :squid => 1.0,
      :octopus => 0.5,
      :nautilus => 0.2 },
    :carole => {
      :squid => 0.2,
      :octopus => 1.0,
      :cuttlefish => 0.4,
      :nautilus => 0.4 },
    :dave => {
      :cuttlefish => 0.9,
      :octopus => 0.4,
      :nautilus => 0.5 }
  }
  
# Ruby test case, should output
#
# {:cuttlefish=>0.25, :octopus=>0.233333333333333, :nautilus=>0.1}

  s = SlopeOne.new
  s.update(userdata)
  p s.predict({ :squid => 0.4})
end

