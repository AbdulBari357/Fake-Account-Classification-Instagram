# ============================================================================
# INSTAGRAM PROFILE ANALYTICS - CLASSIFICATION MODEL
# ============================================================================

# Load and explore data
instagram <- read.csv("C:/Users/abdul/OneDrive/Desktop/MDX/CST4225 - Applied Data Science Lifecycle/Mock Hackathon/instagram.csv")
View(instagram)
summary(instagram)
str(instagram)

# Load required library
library(rpart)

# ============================================================================
# STEP 1: DEFINE DEPENDENT VARIABLE
# ============================================================================

instagram$fake <- as.factor(instagram$fake)

# ============================================================================
# STEP 2: BASELINE MODELS
# ============================================================================

# Set seed for reproducibility
set.seed(123)

# Create train/test split (70% train, 30% test)
n <- nrow(instagram)
train_idx <- sample(seq_len(n), size = round(0.7 * n), replace = FALSE)
train <- instagram[train_idx, ]
test  <- instagram[-train_idx, ]

# --- Baseline Logistic Regression ---
log_base <- glm(fake ~ profile.pic + nums.length.username + X.followers + X.follows,
                data = train,
                family = binomial)

# Predict and evaluate
log_probs <- predict(log_base, newdata = test, type = "response")
log_pred_class <- ifelse(log_probs >= 0.5, "1", "0")
log_pred_class <- factor(log_pred_class, levels = levels(train$fake))

log_cm <- table(Predicted = log_pred_class, Actual = test$fake)
print("Baseline Logistic Regression - Confusion Matrix:")
print(log_cm)
log_accuracy <- sum(diag(log_cm)) / sum(log_cm)
print(paste("Baseline Logistic Regression - Accuracy:", round(log_accuracy, 4)))

# --- Baseline Decision Tree ---
tree_base <- rpart(fake ~ profile.pic + nums.length.username + X.followers + X.follows,
                   data = train, 
                   method = "class")

# Predict and evaluate
tree_pred_class <- predict(tree_base, newdata = test, type = "class")

tree_cm <- table(Predicted = tree_pred_class, Actual = test$fake)
print("Baseline Decision Tree - Confusion Matrix:")
print(tree_cm)
tree_accuracy <- sum(diag(tree_cm)) / sum(tree_cm)
print(paste("Baseline Decision Tree - Accuracy:", round(tree_accuracy, 4)))

# ============================================================================
# STEP 3: IMPROVED MODEL
# ============================================================================

# --- 3.1: Data Quality Issues ---

# Check for missing values
colSums(is.na(instagram))

# Replace missing description.length values with 0
instagram$description.length[is.na(instagram$description.length)] <- 0

# Handle extreme outliers using winsorization (cap at 99th percentile)
cap <- function(x, pct = 0.99) {
  lim <- quantile(x, pct, na.rm = TRUE)
  x[x > lim] <- lim
  return(x)
}

instagram$X.followers <- cap(instagram$X.followers)
instagram$X.follows   <- cap(instagram$X.follows)
instagram$X.posts     <- cap(instagram$X.posts)

# Ensure fake variable remains a factor
instagram$fake <- as.factor(instagram$fake)

# Summary after cleaning
summary(instagram)

# --- 3.2: Feature Engineering ---

# Create follow_ratio: followers / (follows + 1)
instagram$follow_ratio <- instagram$X.followers / (instagram$X.follows + 1)
summary(instagram$follow_ratio)

# --- 3.4: Build Improved Models ---

# Create new train/test split on cleaned data
set.seed(123)
n <- nrow(instagram)
train_idx <- sample(seq_len(n), size = round(0.7 * n))
train <- instagram[train_idx, ]
test  <- instagram[-train_idx, ]

# Improved Logistic Regression
log_improved <- glm(fake ~ profile.pic + nums.length.username + 
                      X.followers + X.follows + follow_ratio,
                    data = train,
                    family = binomial)

summary(log_improved)

# Improved Decision Tree
tree_improved <- rpart(fake ~ profile.pic + nums.length.username +
                         X.followers + X.follows + follow_ratio,
                       data = train,
                       method = "class")

# --- 3.5: Evaluate Improved Models ---

# Evaluate Improved Logistic Regression
prob_imp <- predict(log_improved, newdata = test, type = "response")
pred_imp_log <- ifelse(prob_imp >= 0.5, "1", "0")
pred_imp_log <- factor(pred_imp_log, levels = levels(test$fake))

cm_imp_log <- table(Predicted = pred_imp_log, Actual = test$fake)
print("Improved Logistic Regression - Confusion Matrix:")
print(cm_imp_log)
acc_imp_log <- sum(diag(cm_imp_log)) / sum(cm_imp_log)
print(paste("Improved Logistic Regression - Accuracy:", round(acc_imp_log, 4)))

# Evaluate Improved Decision Tree
tree_pred_imp <- predict(tree_improved, newdata = test, type = "class")

cm_imp_tree <- table(Predicted = tree_pred_imp, Actual = test$fake)
print("Improved Decision Tree - Confusion Matrix:")
print(cm_imp_tree)
acc_imp_tree <- sum(diag(cm_imp_tree)) / sum(cm_imp_tree)
print(paste("Improved Decision Tree - Accuracy:", round(acc_imp_tree, 4)))

# ============================================================================
# FINAL STEP: COMPARISON SUMMARY
# ============================================================================

cat("\n=== MODEL COMPARISON ===\n")
cat("Baseline Logistic Regression Accuracy:", round(log_accuracy, 4), "\n")
cat("Baseline Decision Tree Accuracy:", round(tree_accuracy, 4), "\n")
cat("Improved Logistic Regression Accuracy:", round(acc_imp_log, 4), "\n")
cat("Improved Decision Tree Accuracy:", round(acc_imp_tree, 4), "\n")