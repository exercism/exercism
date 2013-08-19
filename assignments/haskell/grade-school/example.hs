module School (School, empty, grade, add, sorted) where
import qualified Data.Map as M
import qualified Data.Set as S
import Control.Arrow (second)

type Grade = Int
type Student = String
type School = M.Map Grade (S.Set Student)

empty :: School
empty = M.empty

sorted :: School -> [(Grade, [Student])]
sorted = map (second S.toAscList) . M.toAscList

grade :: Grade -> School -> [Student]
grade gradeNum = S.toAscList . M.findWithDefault S.empty gradeNum

add :: Grade -> Student -> School -> School
add gradeNum student = M.insertWith S.union gradeNum (S.singleton student)
