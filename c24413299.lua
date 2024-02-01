--The suppression PLUTO
function c24413299.initial_effect(c)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24413299,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c24413299.target)
	e1:SetOperation(c24413299.operation)
	c:RegisterEffect(e1)
end
function c24413299.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c24413299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and (Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(c24413299.desfilter,tp,0,LOCATION_ONFIELD,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c24413299.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local tg=g:Filter(Card.IsCode,nil,ac)
		local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
		local g2=Duel.GetMatchingGroup(c24413299.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if tg:GetCount()>0 and (g1:GetCount()>0 or g2:GetCount()>0) then
			local op=0
			if g1:GetCount()>0 and g2:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(24413299,1),aux.Stringid(24413299,2))
			elseif g1:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(24413299,1))
			else
				op=Duel.SelectOption(tp,aux.Stringid(24413299,2))+1
			end
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local g=g1:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.GetControl(tc,tp)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=g2:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.HintSelection(g)
					if Duel.Destroy(g,REASON_EFFECT)~=0
						and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
						and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK)
						and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable(true)
						and Duel.SelectYesNo(tp,aux.Stringid(24413299,3)) then
						Duel.BreakEffect()
						Duel.SSet(tp,tc)
					end
				end
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end
