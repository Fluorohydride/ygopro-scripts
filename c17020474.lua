--鬼神 朱沙之王
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET+CATEGORY_MSET+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.cfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,e:GetLabel(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.tgfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x1e4) and c:IsType(TYPE_MONSTER+TYPE_TRAP)
		and (c:IsAbleToHand() or s.setfilter(c,e,tp))
end
function s.setfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.cspfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	local ct=1
	if c:IsAbleToExtra() then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil,e,tp)
	if g:GetCount()==2 then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	else
		e:SetLabel(0)
	end
	local cat=0
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cat=cat|CATEGORY_SPECIAL_SUMMON|CATEGORY_MSET end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cat=cat|CATEGORY_SSET end
	if g:IsExists(s.cspfilter,1,nil) then cat=cat|CATEGORY_GRAVE_SPSUMMON end
	if g:GetCount()>=2 then cat=cat|CATEGORY_TOEXTRA end
	e:SetCategory(cat)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,gg:GetCount(),0,0)
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if aux.NecroValleyNegateCheck(g) then return end
	local sg=g:Filter(aux.NecroValleyFilter(),nil)
	if sg:GetCount()==1 then
		local tc=sg:GetFirst()
		local set=s.setfilter(tc,e,tp)
		if tc:IsAbleToHand()
			and (not set or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif set then
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	elseif sg:GetCount()==2 then
		local tg=sg:Filter(s.setfilter,nil,e,tp)
		local setg=Group.CreateGroup()
		if tg:GetCount()>0 then
			local selg=Group.CreateGroup()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			while true do
				local mct=selg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
				local tct=selg:FilterCount(Card.IsType,nil,TYPE_TRAP)
				local finish=true
				if mct>0 then
					if Duel.IsPlayerAffectedByEffect(tp,59822133) and mct>1 or mct>Duel.GetLocationCount(tp,LOCATION_MZONE) then
						finish=false
					end
				end
				if tct>0 and tct>Duel.GetLocationCount(tp,LOCATION_SZONE) then
					finish=false
				end
				local tmg=tg:Clone()
				tmg:Sub(selg)
				local tc=tmg:SelectUnselect(selg,tp,finish,false,1,tg:GetCount())
				if not tc then
					setg:Merge(selg)
					break
				end
				if selg:IsContains(tc) then
					selg:RemoveCard(tc)
				else
					selg:AddCard(tc)
				end
			end
		end
		local thg=sg-setg
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
		local msg=setg:Filter(Card.IsType,nil,TYPE_MONSTER)
		if msg:GetCount()>0 then
			Duel.SpecialSummon(msg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			if msg:GetCount()==1 then
				Duel.ConfirmCards(1-tp,msg)
			end
		end
		local ssg=setg:Filter(Card.IsType,nil,TYPE_TRAP)
		if ssg:GetCount()>0 then
			Duel.SSet(tp,ssg)
		end
	end
	if e:GetLabel()==1 and sg:GetCount()>0 and c:IsRelateToChain() then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
