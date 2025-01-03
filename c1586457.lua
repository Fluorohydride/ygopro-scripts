--ディープ・スペース・クルーザー・ナイン
---@param c Card
function c1586457.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1586457.spcon)
	e1:SetTarget(c1586457.sptg)
	e1:SetOperation(c1586457.spop)
	c:RegisterEffect(e1)
end
function c1586457.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c1586457.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1586457.filter,tp,LOCATION_HAND,0,1,c)
end
function c1586457.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c1586457.filter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c1586457.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
