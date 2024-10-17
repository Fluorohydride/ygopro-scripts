--氷の王 ニードヘッグ
---@param c Card
function c49275969.initial_effect(c)
	c:SetUniqueOnField(1,0,49275969)
	--disable special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49275969,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,49275969)
	e1:SetCondition(c49275969.discon)
	e1:SetCost(c49275969.discost)
	e1:SetTarget(c49275969.distg)
	e1:SetOperation(c49275969.disop)
	c:RegisterEffect(e1)
end
function c49275969.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c49275969.costfilter(c)
	return c:IsSetCard(0x134) or c:IsRace(RACE_WYRM)
end
function c49275969.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c49275969.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c49275969.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c49275969.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c49275969.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
