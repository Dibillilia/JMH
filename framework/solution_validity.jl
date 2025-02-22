"""returns the solution .* the objective function"""
function score_solution(solution::BitList, problem::ProblemInstance)::Int
    return sum(problem.objective .* solution)
end

"""determines if the solution violates any constraints"""
function is_valid(solution::BitList, problem::ProblemInstance)::Bool
    for upper_bound in problem.upper_bounds
        if sum(upper_bound[1] .* solution) > upper_bound[2]
            return false
        end
    end
    for lower_bound in problem.lower_bounds
        if sum(lower_bound[1] .* solution) < lower_bound[2]
            return false
        end
    end
    return true
end

"""returns a numerical value describing how far over the upper bound a solution is. Returns 0 if
it is a valid solution."""
function violates_upper(solution::BitList, problem::ProblemInstance)::Int
    #This used to be called by repair_op but now it's smarter and can cache violations.
    #I keep this function here to use it in the REPL for debugging.
    violation = 0
    for upper_bound in problem.upper_bounds
        total = sum(upper_bound[1] .* solution)
        if total > upper_bound[2]
            valid = false
            violation += total - upper_bound[2]
        end
    end
    return violation
end

"""returns a numerical value describing how far under the lower bound a solution is. Returns 0 if
it is a valid solution"""
function violates_lower(solution::BitList, problem::ProblemInstance)::Int
    #This used to be called by repair_op but now it's smarter and can cache violations.
    #I keep this function here to use it in the REPL for debugging.
    violation = 0
    for lower_bound in problem.lower_bounds
        total = sum(lower_bound[1] .* solution)
        if total < lower_bound[2]
            violation += lower_bound[2] - total
        end
    end
    return violation
end

"""determines if solution violates one of the lower bounds"""
function violates_demands(solution::BitList, problem::ProblemInstance)::Bool
    for lower_bound in problem.lower_bounds
        total = sum(lower_bound[1] .* solution)
        if total < lower_bound[2]
            return true
        end
    end
    return false
end

"""determines if solution violates one of the lower bounds"""
function violates_dimensions(solution::BitList, problem::ProblemInstance)::Bool
    for upper_bound in problem.upper_bounds
        total = sum(upper_bound[1] .* solution)
        if total > upper_bound[2]
            return true
        end
    end
    return false
end
