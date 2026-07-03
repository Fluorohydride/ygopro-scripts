--ジャンクスリープ
function c56294501.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--turn faceup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56294501,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,56294501)
	e2:SetCondition(c56294501.chcon)
	e2:SetTarget(c56294501.chtg)
	e2:SetOperation(c56294501.chop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--turn facedown
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(56294501,1))
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,56294502)
	e4:SetTarget(c56294501.chtg2)
	e4:SetOperation(c56294501.chop2)
	c:RegisterEffect(e4)
end
function c56294501.filter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function c56294501.chcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c56294501.filter,1,nil,tp)
end
function c56294501.chfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c56294501.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56294501.chfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c56294501.chfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c56294501.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c56294501.chfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
end
function c56294501.chtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c56294501.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
