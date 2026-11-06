--魂宿りし暗黒騎士ガイア
local s,id,o=GetID()
function s.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.lvfilter)
	e2:SetValue(7)
	c:RegisterEffect(e2)
	--record
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.lvcon)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.negcon)
	e5:SetCost(s.negcost)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)
end
function s.cfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
		and (c:IsLevelAbove(5) and c:IsLocation(LOCATION_MZONE)
		or c:GetOriginalLevel()>4 and not c:IsLocation(LOCATION_MZONE))
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.lvcfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsLevelAbove(1) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsLocation(LOCATION_MZONE)
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.lvcfilter,1,nil,1-tp) and not eg:IsContains(e:GetHandler())
end
function s.lvfilter(e,c)
	local fid=c:GetRealFieldID()
	local labels={e:GetHandler():GetFlagEffectLabel(id)}
	for i=1,#labels do
		if labels[i]==fid then
			return true
		end
	end
	return false
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.lvcfilter,nil,1-tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	for tc in aux.Next(g) do
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,tc:GetRealFieldID())
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and Duel.IsChainNegatable(ev)
end
function s.costfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
		and (c:IsLevelAbove(5) and c:IsLocation(LOCATION_MZONE)
		or c:GetOriginalLevel()>4 and not c:IsLocation(LOCATION_MZONE))
		and c:IsAbleToGraveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
