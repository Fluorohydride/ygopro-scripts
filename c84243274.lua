--VWXYZ－ドラゴン・カタパルトキャノン
function c84243274.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,58859575,91998119,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c84243274.splimit)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84243274,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c84243274.rmtg)
	e3:SetOperation(c84243274.rmop)
	c:RegisterEffect(e3)
	--poschange
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84243274,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c84243274.postg)
	e4:SetOperation(c84243274.posop)
	c:RegisterEffect(e4)
end
function c84243274.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c84243274.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c84243274.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c84243274.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local bc=Duel.GetAttackTarget()
	if chk==0 then return bc and bc:IsCanChangePosition() and bc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,bc,1,0,0)
end
function c84243274.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	end
end
