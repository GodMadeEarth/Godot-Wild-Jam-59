extends Resource
class_name SaveHighScore

@export var hightscores:Array[int] = []
const SAVE_PATH := "res://saves/highscores.tres"

func save():
	ResourceSaver.save(self,SAVE_PATH)
	pass

func update_highscore():
	var score = GlobalData.score
	hightscores = await load_scores().hightscores
	if hightscores.size() == 10:
		for i in 10:
			if hightscores[i] <= score:
				hightscores[i] = score
				break
	else:
		hightscores.append(score)
	hightscores.sort_custom(func(a, b): return a < b)
#		print(hightscores)
	pass

static func load_scores():
	if ResourceLoader.exists(SAVE_PATH):
		return load(SAVE_PATH)
	return null
