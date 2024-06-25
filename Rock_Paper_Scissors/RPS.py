# The example function below keeps track of the opponent's history and plays whatever the opponent played two plays ago. It is not a very good player so you will need to change the code to pass the challenge.
from itertools import product
#Creating all combinations of plays for five moves.
list1 = ['R','P','S']
list2 = [''.join(i) for i in product(list1, repeat=5)]
play_order = [{i:0 for i in list2}]
def player(prev_play, opponent_history=[]):

    if not prev_play:
        prev_play: 'S'
    opponent_history.append(prev_play)

    last_five_plays = ''.join(opponent_history[-5:])
    if len(last_five_plays) == 5:
        play_order[0][last_five_plays]+=1

    potential_plays = [
        ''.join(opponent_history[-4:]) + i for i in list1
    ]

    sub_order = {
        k:play_order[0][k]
        for k in potential_plays if k in play_order[0]
    }
    if len(last_five_plays) >= 5:
        pred = max(sub_order, key = sub_order.get)[-1]
    else:
        pred='P'
    ideal_response = {'P': 'S', 'R': 'P', 'S': 'R'}
    return ideal_response[pred]