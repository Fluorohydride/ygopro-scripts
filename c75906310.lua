--アームド・ドラゴン・カタパルトキャノン
function c75906310.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,84243274,73879377,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c75906310.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c75906310.spcon)
	e2:SetOperation(c75906310.spop)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c75906310.aclimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75906310,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c75906310.rmcon)
	e4:SetCost(c75906310.rmcost)
	e4:SetTarget(c75906310.rmtg)
	e4:SetOperation(c75906310.rmop)
	c:RegisterEffect(e4)
	if not c75906310.global_flag then
		c75906310.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c75906310.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75906310.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(84243274) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),75906310,0,0,0)
		elseif tc:IsCode(73879377) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),75906311,0,0,0)
		end
	end
end
function c75906310.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c75906310.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsFusionCode(84243274,73879377) and c:IsAbleToRemoveAsCost()
end
function c75906310.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c75906310.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c75906310.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c75906310.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c75906310.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c75906310.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c75906310.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return Duel.GetFlagEffect(tp,75906310)>0 and Duel.GetFlagEffect(tp,75906311)>0
		and mg:IsExists(c75906310.fselect,1,nil,tp,mg,sg,84243274,73879377)
end
function c75906310.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c75906310.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c75906310.fselect,1,1,sg,tp,mg,sg,84243274,73879377)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c75906310.acfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c75906310.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c75906310.acfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,1,nil,re:GetHandler():GetCode())
		and not re:GetHandler():IsImmuneToEffect(e)
end
function c75906310.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c75906310.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75906310.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c75906310.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
