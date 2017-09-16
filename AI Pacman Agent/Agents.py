from game import Agent
from game import Directions
from pacman import GameState
import random

class DumbAgent (Agent):
	"An agent that goes West until it can't."

	def getAction(self, state):
		"The agent receives a GameState (defined in pacman.py). "
		print "Location: ", state.getPacmanPosition()
		print "Actinos available: ", state.getLegalPacmanActions()
		if Directions.WEST in state.getLegalPacmanActions(): 
			print "Going West."
			return Directions.WEST 
		else: 
			print "Going West."
			return Directions.STOP 
			
class RandomAgent (Agent): 
	"An agent that acts on random actions. "
	
	def getAction(self, state):
		"The agent receives a GameState (defined in pacman.py). "
		print "Location: ", state.getPacmanPosition()
		actionList = state.getLegalPacmanActions()
		actionList.remove(Directions.STOP);
		print "Actions availvale: ", actionList
		action = random.choice(actionList)
		print "Going ", action
		return action

class ReflexAgent (Agent):
	"An agent that acts upon the change of the environment. "

	def getAction(self, state):
		"The agent receives a GameState (defined in pacman.py). "
		agentLoc = state.getPacmanPosition()
		print "Location: ", agentLoc
		actionList = state.getLegalPacmanActions()
		actionList.remove(Directions.STOP);
		foodList = filter (lambda x: state.hasFood(state.generateSuccessor(0, x).getPacmanPosition()[0], state.generateSuccessor(0, x).getPacmanPosition()[1]) , actionList)
		if foodList == []:
			print "No food nearby sad :("
			action = random.choice(actionList)
		else: 
			print "Possible moves to get food: ", foodList
			action = random.choice(foodList)
			print "Going ", action
		return action



