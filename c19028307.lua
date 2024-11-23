--獣神機王バルバロスUr
---@param c Card
function c19028307.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19028307.spcon)
	e1:SetTarget(c19028307.sptg)
	e1:SetOperation(c19028307.spop)
	c:RegisterEffect(e1)
	--no battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
end
function c19028307.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_BEASTWARRIOR+RACE_MACHINE) and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c19028307.spcheck(sg,tp)
	return Duel.GetMZoneCount(tp,sg,tp)>0 and aux.gfcheck(sg,Card.IsRace,RACE_BEASTWARRIOR,RACE_MACHINE)
end
function c19028307.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c19028307.spcostfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,c)
	return g:CheckSubGroup(c19028307.spcheck,2,2,tp)
end
function c19028307.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c19028307.spcostfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c19028307.spcheck,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c19028307.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
