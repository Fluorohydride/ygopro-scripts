--絶無なる獄神界－ヴィードリア
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53589300,68231287,5914858)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.value1)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(s.actcon)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end
function s.value1(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*(-100)
end
function s.cfilter(c,e,tp)
	return c:IsSetCard(0x1ce) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function s.thfilter(c,e,tp,cid)
	if not (aux.IsCodeListed(c,cid) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local exg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=exg:Select(tp,1,1,nil):GetFirst()
	e:SetLabel(fc:GetCode())
	Duel.ConfirmCards(1-tp,fc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local rc=rg:GetFirst()
	if rc and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,cid)
		local tc=g:GetFirst()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if tc then
			Duel.BreakEffect()
			local spchk=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0
			if tc:IsAbleToHand() and (not spchk or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			elseif spchk then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.cofilter(c,cid)
	return c:IsFaceup() and c:IsCode(cid)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.cofilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,53589300)
		and Duel.IsExistingMatchingCard(s.cofilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,68231287)
		and Duel.IsExistingMatchingCard(s.cofilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,5914858)
end
function s.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
