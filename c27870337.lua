--ドレミコード・エレガンス
function c27870337.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27870337+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27870337.target)
	e1:SetOperation(c27870337.activate)
	c:RegisterEffect(e1)
end
function c27870337.pendfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c27870337.pendfilter1(c)
	return c27870337.pendfilter(c) and c:GetCurrentScale()%2~=0
end
function c27870337.pendfilter2(c)
	return c27870337.pendfilter(c) and c:GetCurrentScale()%2==0
end
function c27870337.toexfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM)
end
function c27870337.toexfilter1(c)
	return c:GetCurrentScale()%2~=0
end
function c27870337.toexfilter2(c)
	return c:GetCurrentScale()%2==0
end
function c27870337.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c27870337.pendfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local b2=Duel.IsExistingMatchingCard(c27870337.toexfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c27870337.pendfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c27870337.pendfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b3=Duel.IsExistingMatchingCard(c27870337.toexfilter1,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c27870337.toexfilter2,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(27870337,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(27870337,1)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(27870337,2)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(0)
	elseif sel==1 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c27870337.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,c27870337.pendfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27870337,3))
		local g=Duel.SelectMatchingCard(tp,c27870337.toexfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT)~=0
			and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			local g1=Duel.GetMatchingGroup(c27870337.pendfilter1,tp,LOCATION_DECK,0,nil)
			local g2=Duel.GetMatchingGroup(c27870337.pendfilter2,tp,LOCATION_DECK,0,nil)
			if g1:GetCount()>0 and g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				local tc=sg1:GetFirst()
				while tc do
					Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
					tc=sg1:GetNext()
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27870337,3))
		local g1=Duel.SelectMatchingCard(tp,c27870337.toexfilter1,tp,LOCATION_PZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27870337,3))
		local g2=Duel.SelectMatchingCard(tp,c27870337.toexfilter2,tp,LOCATION_PZONE,0,1,1,nil)
		g1:Merge(g2)
		if Duel.SendtoExtraP(g1,nil,REASON_EFFECT)~=0 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
	end
end
