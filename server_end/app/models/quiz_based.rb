class QuizBased < ActiveRecord::Base
	###############################################
	#Define Quiz-based algorithm
	#parameters:
	#'submissions' 		hash with 'rating_records' array
	#'quiz_scores'      hash
	###############################################
	def self.calculate_predicted_grades(submissions)
		predicted_grades = Hash.new

		submissions.each do |key, submission|
			review_records = submission.review_records
			weighted_score_sum = 0
			weight_sum = 0
			review_records.each do |rr|
				if rr.score >= 80
					weighted_score_sum += rr.score * rr.quiz_score
					weight_sum += rr.quiz_score
				else
					temp_weight = 60
					weighted_score_sum += rr.score * temp_weight
					weight_sum += temp_weight
				end
			end

			predicted_grades[submission.id] = (1.0 * weighted_score_sum / weight_sum).round(4)
		end
		predicted_grades.sort_by{|key, grade| key.to_i}.to_h.each do |key, grade|
			puts 'submission' + key.to_s + ': ' + grade.to_s
		end
		return predicted_grades
	end
end
