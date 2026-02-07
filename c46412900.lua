--ヴォルカニック・エンペラー
function c46412900.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(46412900)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon(remove 3 monster)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46412900,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c46412900.sprcon)
	e1:SetTarget(c46412900.sprtg)
	e1:SetOperation(c46412900.sprop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Burn and Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46412900,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c46412900.damcon)
	e2:SetTarget(c46412900.damtg)
	e2:SetOperation(c46412900.damop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c46412900.damcon2)
	e3:SetOperation(c46412900.damop2)
	c:RegisterEffect(e3)
end
function c46412900.sprfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
		and (c:IsRace(RACE_PYRO) and c:IsType(TYPE_MONSTER) or c:IsSetCard(0xb9))
end
function c46412900.gcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
		and (#g==3 and g:FilterCount(Card.IsRace,nil,RACE_PYRO)==3
			or #g==1 and g:FilterCount(Card.IsSetCard,nil,0xb9)==1)
end
function c46412900.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c46412900.sprfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,e:GetHandler())
	return g:CheckSubGroup(c46412900.gcheck,1,3,tp)
end
function c46412900.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c46412900.sprfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c46412900.gcheck,true,1,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c46412900.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c46412900.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c46412900.damfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsFaceup()
end
function c46412900.scfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x32) and c:IsSSetable()
end
function c46412900.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46412900.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local val=Duel.GetMatchingGroupCount(c46412900.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c46412900.damop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(c46412900.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
	if Duel.Damage(1-tp,val,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(c46412900.scfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(46412900,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c46412900.scfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp,g:GetFirst())
	end
end
function c46412900.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c46412900.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c46412900.cfilter,1,nil,1-tp)
end
function c46412900.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,46412900)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
