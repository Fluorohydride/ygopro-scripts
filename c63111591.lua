--躯売りのカラス
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.setfilter(c,tp)
	return not c:IsCode(id) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_TRAP)
	local ct=g:GetClassCount(Card.GetCode)+1
	if ct>4 then ct=4 end
	local st={}
	if ct>1 then
		for i=ct,1,-1 do
			if Duel.IsPlayerCanDiscardDeck(tp,i) then
				table.insert(st,i)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		ct=Duel.AnnounceNumber(tp,table.unpack(st))
	end
	if Duel.DiscardDeck(tp,ct,REASON_EFFECT)~=0 then
		local sg=Duel.GetOperatedGroup():Filter(aux.NecroValleyFilter(Card.IsLocation),nil,LOCATION_GRAVE)
		if sg:GetCount()>0 then
			Duel.AdjustAll()
			local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and sg:IsExists(s.spfilter,1,nil,e,tp)
			local b2=sg:IsExists(s.setfilter,1,nil,tp)
			local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(id,2)},
				{b2,aux.Stringid(id,3)},
				{true,aux.Stringid(id,4)})
			if op==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:FilterSelect(tp,s.spfilter,1,1,nil,e,tp)
				if tg:GetCount()>0 then
					Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif op==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local tg=sg:FilterSelect(tp,s.setfilter,1,1,nil,tp)
				local tc=tg:GetFirst()
				if tc then
					Duel.SSet(tp,tc)
					if tc:IsType(TYPE_TRAP+TYPE_QUICKPLAY) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetDescription(aux.Stringid(id,5))
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						if tc:IsType(TYPE_TRAP) then
							e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						else
							e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						end
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end
