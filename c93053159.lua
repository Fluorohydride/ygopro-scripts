--白の枢機竜
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcCodeFun(c,68468459,s.mfilter,6,true,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(s.atcost)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.samecheck(c,sg)
	local fuscodes={c:GetFusionCode()}
	for _,code in ipairs(fuscodes) do
		if not sg:IsExists(Card.IsCode,1,nil,code) then return true end
	end
	return false
end
function s.migfilter(c,fc)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(fc:GetControler())
end

if not s.abs_list then
	s.abs_list={}
end

function s.mfilter(c,fc,sub,mg,sg)
	if not s.migfilter(c,fc) then return false end
	if sg then
		if #sg==0 then return false end -- must select at 2nd place, to determine which one is abs
		if #sg==1 then
			s.abs_list[fc]=sg:GetFirst()
			return true
		end
		return s.samecheck(c,sg-s.abs_list[fc])
	end
	return true
end
function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function s.cfilter(c)
	return aux.IsMaterialListCode(c,68468459)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
		and g:GetClassCount(Card.GetCode)>5
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
