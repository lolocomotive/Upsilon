extern "C" {
#include <assert.h>
#include <math.h>
}
#include <poincare/power.h>
#include <poincare/multiplication.h>
#include "layout/baseline_relative_layout.h"

float Power::approximate(Context& context) const {
  return powf(m_operands[0]->approximate(context), m_operands[1]->approximate(context));
}

Expression * Power::evaluateOnMatrixAndFloat(Matrix * m, Float * a, Context& context) const {
  if (m_operands[1]->type() != Expression::Type::Integer) {
    return nullptr;
  }
 if (m->numberOfColumns() != m->numberOfRows()) {
    return nullptr;
  }
  // TODO: return identity matrix if i == 0
  int power = a->approximate(context);
  Expression * result = new Float(1);
  for (int k = 0; k < power; k++) {
    Expression * operands[2];
    operands[0] = result;
    operands[1] = m;
    Expression * multiplication = new Multiplication(operands, true);
    Expression * newResult = multiplication->evaluate(context);
    delete result;
    result = newResult;
    delete multiplication;
  }
  return result;
}

Expression::Type Power::type() const {
  return Type::Power;
}

Expression * Power::cloneWithDifferentOperands(Expression** newOperands,
    int numberOfOperands, bool cloneOperands) const {
  assert(numberOfOperands == 2);
  return new Power(newOperands, cloneOperands);
}

ExpressionLayout * Power::createLayout() const {
  Expression * indiceOperand = m_operands[1];
  // Delete eventual parentheses of the indice in the pretty print
  if (m_operands[1]->type() == Type::Parenthesis) {
    indiceOperand = (Expression *)m_operands[1]->operand(0);
  }
  return new BaselineRelativeLayout(m_operands[0]->createLayout(),indiceOperand->createLayout(), BaselineRelativeLayout::Type::Superscript);
}
