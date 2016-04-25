--ファイナル・ギアス
function c16832845.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_TOGRAVE)
	e1:SetCondition(c16832845.condition)
	e1:SetTarget(c16832845.target)
	e1:SetOperation(c16832845.activate)
	c:RegisterEffect(e1)	
	if not c16832845.global_check then
		c16832845.global_check=true
		c16832845[0]=false
		c16832845[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c16832845.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c16832845.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c16832845.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalLevel()>=7 and tc:IsPreviousLocation(LOCATION_MZONE) then
			c16832845[tc:GetPreviousControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c16832845.clear(e,tp,eg,ep,ev,re,r,rp)
	c16832845[0]=false
	c16832845[1]=false
end
function c16832845.condition(e,tp,eg,ep,ev,re,r,rp)
	return c16832845[0] and c16832845[1]
end
function c16832845.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c16832845.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16832845.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c16832845.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:FilterCount(Card.IsControler,nil,1-tp)==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_GRAVE)
	elseif g:FilterCount(Card.IsControler,nil,tp)==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),PLAYER_ALL,LOCATION_GRAVE)
	end
end
function c16832845.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_REMOVED) and c:GetLevel()>0
end
function c16832845.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16832845.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(c16832845.spfilter,nil,e,tp)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16832845,0)) then
			Duel.BreakEffect()
			local sg=og:GetMaxGroup(Card.GetLevel)
			if sg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,1,1,nil)
			end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
